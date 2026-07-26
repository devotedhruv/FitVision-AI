"""Privacy-safe request correlation and bounded process-local rate limiting."""

from __future__ import annotations

import asyncio
import time
from collections import OrderedDict, deque
from uuid import uuid4

from fastapi import Request
from starlette.datastructures import MutableHeaders
from starlette.responses import JSONResponse
from starlette.types import ASGIApp, Message, Receive, Scope, Send

from app.core.config import Settings


class RequestHardeningMiddleware:
    """Attach correlation IDs and constrain accidental API abuse.

    The limiter is deliberately a bounded per-process safety net. Production
    multi-instance deployments must put a shared limiter at the gateway/Redis
    boundary; this limitation is documented and never represented as global.
    """

    def __init__(self, app: ASGIApp, settings: Settings):
        self.app = app
        self.settings = settings
        self._buckets: OrderedDict[str, deque[float]] = OrderedDict()
        self._lock = asyncio.Lock()

    async def __call__(self, scope: Scope, receive: Receive, send: Send) -> None:
        if scope["type"] != "http":
            await self.app(scope, receive, send)
            return
        request = Request(scope)
        request_id = self._request_id(request.headers.get("X-Request-ID"))
        request.state.request_id = request_id
        if self.settings.RATE_LIMIT_ENABLED and not await self._allow(request):
            response = JSONResponse(
                status_code=429,
                headers={
                    "Retry-After": str(self.settings.RATE_LIMIT_WINDOW_SECONDS),
                    "X-Request-ID": request_id,
                },
                content={
                    "error": {
                        "code": "RATE_LIMITED",
                        "message": "Too many requests. Please retry shortly.",
                    }
                },
            )
            await response(scope, receive, send)
            return

        async def send_with_request_id(message: Message) -> None:
            if message["type"] == "http.response.start":
                MutableHeaders(scope=message)["X-Request-ID"] = request_id
            await send(message)

        await self.app(scope, receive, send_with_request_id)

    @staticmethod
    def _request_id(candidate: str | None) -> str:
        if (
            candidate
            and 1 <= len(candidate) <= 64
            and all(c.isalnum() or c in "-_." for c in candidate)
        ):
            return candidate
        return str(uuid4())

    async def _allow(self, request: Request) -> bool:
        # Raw authorization credentials are intentionally never part of the key.
        client = request.client.host if request.client else "unknown"
        key = f"{client}:{request.url.path}"
        now = time.monotonic()
        cutoff = now - self.settings.RATE_LIMIT_WINDOW_SECONDS
        async with self._lock:
            bucket = self._buckets.setdefault(key, deque())
            while bucket and bucket[0] <= cutoff:
                bucket.popleft()
            allowed = len(bucket) < self.settings.RATE_LIMIT_REQUESTS
            if allowed:
                bucket.append(now)
            self._buckets.move_to_end(key)
            while len(self._buckets) > self.settings.RATE_LIMIT_BUCKET_CAPACITY:
                self._buckets.popitem(last=False)
            return allowed
