"""FitVision AI FastAPI application factory and importable app."""

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, RedirectResponse
from sqlalchemy import text

from app.api.router import api_router
from app.core.config import Settings, get_settings
from app.core.exceptions import register_exception_handlers
from app.core.logging import configure_logging
from app.core.request_hardening import RequestHardeningMiddleware
from app.db.session import dispose_engine, get_engine


def create_app(settings: Settings | None = None) -> FastAPI:
    """Build the ASGI application without starting a development server."""

    runtime_settings = settings or get_settings()
    configure_logging(runtime_settings.LOG_LEVEL)

    @asynccontextmanager
    async def lifespan(application: FastAPI):
        yield
        await dispose_engine(application)

    docs_enabled = runtime_settings.DOCS_ENABLED and runtime_settings.APP_ENV != "production"
    application = FastAPI(
        title=runtime_settings.APP_NAME,
        version=runtime_settings.APP_VERSION,
        lifespan=lifespan,
        docs_url="/docs" if docs_enabled else None,
        redoc_url="/redoc" if docs_enabled else None,
        openapi_url="/openapi.json" if docs_enabled else None,
    )
    application.state.settings = runtime_settings
    application.add_middleware(
        CORSMiddleware,
        allow_origins=runtime_settings.CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
        allow_headers=["Authorization", "Content-Type", "Accept"],
    )
    application.add_middleware(RequestHardeningMiddleware, settings=runtime_settings)
    application.include_router(api_router, prefix=runtime_settings.API_V1_PREFIX)
    register_exception_handlers(application)

    @application.get("/", include_in_schema=False)
    async def root() -> RedirectResponse:
        return RedirectResponse(
            url="/docs" if docs_enabled else runtime_settings.API_V1_PREFIX + "/health",
            status_code=307,
        )

    @application.get(
        runtime_settings.API_V1_PREFIX + "/readiness",
        tags=["health"],
        summary="Check database readiness",
    )
    async def readiness():
        if not runtime_settings.DATABASE_URL:
            return JSONResponse(
                status_code=503,
                content={"status": "not_ready", "reason": "database_not_configured"},
            )
        try:
            async with get_engine_from_app(application).connect() as connection:
                await connection.execute(text("SELECT 1"))
        except Exception:
            return JSONResponse(
                status_code=503,
                content={"status": "not_ready", "reason": "database_unavailable"},
            )
        return {"status": "ready"}

    return application


def get_engine_from_app(application: FastAPI):
    """Use the same lazy engine path as request dependencies."""

    class AppRequest:
        app = application

    return get_engine(AppRequest())


app = create_app()
