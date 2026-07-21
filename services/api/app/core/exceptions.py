"""Application error type and safe response handler."""

from typing import Any

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse


class ApplicationError(Exception):
    """An expected API error safe to describe to clients."""

    def __init__(self, message: str, *, code: str = "application_error", status_code: int = 400):
        super().__init__(message)
        self.message = message
        self.code = code
        self.status_code = status_code


def register_exception_handlers(app: FastAPI) -> None:
    """Register a stable JSON envelope for expected application failures."""

    @app.exception_handler(ApplicationError)
    async def handle_application_error(
        _request: Request, exception: ApplicationError
    ) -> JSONResponse:
        content: dict[str, Any] = {
            "error": {"code": exception.code, "message": exception.message}
        }
        return JSONResponse(status_code=exception.status_code, content=content)

