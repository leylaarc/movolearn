from __future__ import annotations

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response

from .config import get_settings
from .db import Base, engine
from .routers import auth, family

settings = get_settings()

if settings.is_production and (
    not settings.secret_key or settings.secret_key.startswith("dev-") or settings.secret_key == "replace-with-a-long-random-string"
):
    raise RuntimeError("FAMILY_API_SECRET_KEY must be a long random value in production.")


class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next) -> Response:
        response = await call_next(request)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["Referrer-Policy"] = "no-referrer"
        response.headers["Cache-Control"] = "no-store"
        response.headers["X-Frame-Options"] = "DENY"
        return response


def create_app() -> FastAPI:
    Base.metadata.create_all(bind=engine)
    application = FastAPI(
        title="Movo Learn Family API",
        version="1.0.0",
        docs_url=None if settings.is_production else "/docs",
        redoc_url=None,
        openapi_url=None if settings.is_production else "/openapi.json",
    )
    application.add_middleware(SecurityHeadersMiddleware)
    origins = settings.cors_origin_list
    if origins:
        application.add_middleware(
            CORSMiddleware,
            allow_origins=origins,
            allow_credentials=False,
            allow_methods=["GET", "POST", "PUT", "DELETE"],
            allow_headers=["Authorization", "Content-Type"],
        )
    application.include_router(auth.router)
    application.include_router(family.router)

    @application.get("/health")
    def health() -> dict[str, str]:
        return {"status": "ok"}

    return application


app = create_app()
