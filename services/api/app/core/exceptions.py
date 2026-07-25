"""Domain errors and safe FastAPI exception handlers."""

import logging
from typing import Any

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from sqlalchemy.exc import SQLAlchemyError
from starlette.exceptions import HTTPException as StarletteHTTPException

logger = logging.getLogger(__name__)


class ApplicationError(Exception):
    def __init__(self, message: str, *, code: str, status_code: int):
        super().__init__(message)
        self.message = message
        self.code = code
        self.status_code = status_code


class AuthenticationError(ApplicationError):
    def __init__(self, message: str = "Authentication is required."):
        super().__init__(message, code="AUTHENTICATION_REQUIRED", status_code=401)


class PermissionDeniedError(ApplicationError):
    def __init__(self, message: str = "You do not have permission for this action."):
        super().__init__(message, code="PERMISSION_DENIED", status_code=403)


class ResourceNotFoundError(ApplicationError):
    def __init__(self, message: str = "The requested resource was not found."):
        super().__init__(message, code="RESOURCE_NOT_FOUND", status_code=404)


class ConflictError(ApplicationError):
    def __init__(self, message: str):
        super().__init__(message, code="RESOURCE_CONFLICT", status_code=409)


class DomainValidationError(ApplicationError):
    def __init__(self, message: str):
        super().__init__(message, code="INVALID_REQUEST", status_code=422)


def register_exception_handlers(app: FastAPI) -> None:
    @app.exception_handler(StarletteHTTPException)
    async def handle_http_error(
        _request: Request, exception: StarletteHTTPException
    ) -> JSONResponse:
        code = "RESOURCE_NOT_FOUND" if exception.status_code == 404 else "HTTP_ERROR"
        message = (
            "The requested resource was not found."
            if exception.status_code == 404
            else "The request could not be completed."
        )
        return JSONResponse(
            status_code=exception.status_code,
            content={"error": {"code": code, "message": message}},
        )

    @app.exception_handler(ApplicationError)
    async def handle_application_error(
        _request: Request, exception: ApplicationError
    ) -> JSONResponse:
        return JSONResponse(
            status_code=exception.status_code,
            content={"error": {"code": exception.code, "message": exception.message}},
            headers={"WWW-Authenticate": "Bearer"} if exception.status_code == 401 else None,
        )

    @app.exception_handler(RequestValidationError)
    async def handle_validation_error(
        _request: Request, exception: RequestValidationError
    ) -> JSONResponse:
        details: list[dict[str, Any]] = []
        for item in exception.errors():
            details.append(
                {
                    "location": [str(part) for part in item["loc"]],
                    "message": item["msg"],
                    "type": item["type"],
                }
            )
        return JSONResponse(
            status_code=422,
            content={
                "error": {
                    "code": "VALIDATION_ERROR",
                    "message": "The request data is invalid.",
                    "details": details,
                }
            },
        )

    @app.exception_handler(SQLAlchemyError)
    async def handle_database_error(_request: Request, exception: SQLAlchemyError) -> JSONResponse:
        logger.exception("Database operation failed", exc_info=exception)
        return JSONResponse(
            status_code=503,
            content={
                "error": {
                    "code": "DATABASE_UNAVAILABLE",
                    "message": "The data service is temporarily unavailable.",
                }
            },
        )
