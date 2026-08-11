from __future__ import annotations

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse


class FeedWiseError(Exception):
    status_code: int = 400
    code: str = "feedwise_error"

    def __init__(self, message: str, *, details: dict | None = None) -> None:
        self.message = message
        self.details = details or {}
        super().__init__(message)


class AuthenticationError(FeedWiseError):
    status_code = 401
    code = "authentication_error"


class AuthorizationError(FeedWiseError):
    status_code = 403
    code = "authorization_error"


class NotFoundError(FeedWiseError):
    status_code = 404
    code = "not_found"


class ConflictError(FeedWiseError):
    status_code = 409
    code = "conflict"


class ValidationError(FeedWiseError):
    status_code = 422
    code = "validation_error"


async def feedwise_error_handler(_: Request, exc: FeedWiseError) -> JSONResponse:
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": exc.code,
                "message": exc.message,
                "details": exc.details,
            }
        },
    )


async def unhandled_error_handler(_: Request, exc: Exception) -> JSONResponse:
    return JSONResponse(
        status_code=500,
        content={
            "error": {
                "code": "internal_server_error",
                "message": "Unexpected server error",
                "details": {"type": type(exc).__name__},
            }
        },
    )


def register_exception_handlers(app: FastAPI) -> None:
    app.add_exception_handler(FeedWiseError, feedwise_error_handler)
    app.add_exception_handler(Exception, unhandled_error_handler)
