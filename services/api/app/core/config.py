"""Validated environment-driven API settings."""

from functools import lru_cache
from typing import Literal
from urllib.parse import quote

from pydantic import Field, SecretStr, field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Validated runtime settings with safe development defaults."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
        case_sensitive=True,
    )

    APP_NAME: str = "FitVision AI API"
    APP_ENV: str = "development"
    APP_VERSION: str = "0.3.0"
    API_V1_PREFIX: str = "/api/v1"
    API_HOST: str = "0.0.0.0"
    API_PORT: int = Field(default=8000, ge=1, le=65535)
    LOG_LEVEL: str = "INFO"
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]
    DATABASE_URL: str | None = None
    TEST_DATABASE_URL: str | None = None
    DB_HOST: str | None = None
    DB_PORT: int = Field(default=5432, ge=1, le=65535)
    DB_NAME: str = "postgres"
    DB_USER: str | None = None
    DB_PASSWORD: SecretStr | None = None
    SUPABASE_URL: str | None = None
    SUPABASE_PUBLISHABLE_KEY: str | None = None
    SUPABASE_JWT_ISSUER: str | None = None
    SUPABASE_JWT_AUDIENCE: str = "authenticated"
    SUPABASE_JWKS_URL: str | None = None
    SUPABASE_JWT_ALGORITHMS: list[Literal["RS256", "RS384", "RS512", "ES256", "ES384"]] = [
        "ES256",
        "RS256",
    ]
    AUTH_PROVIDER: Literal["supabase", "clerk"] = "supabase"
    CLERK_ISSUER: str | None = None
    CLERK_JWKS_URL: str | None = None
    CLERK_AUDIENCE: str | None = None
    CLERK_AUTHORIZED_PARTIES: list[str] = []
    DB_POOL_SIZE: int = Field(default=5, ge=1, le=50)
    DB_MAX_OVERFLOW: int = Field(default=10, ge=0, le=100)
    DB_POOL_TIMEOUT: int = Field(default=30, ge=1, le=300)
    DB_ECHO: bool = False
    DOCS_ENABLED: bool = True
    RATE_LIMIT_ENABLED: bool = True
    RATE_LIMIT_REQUESTS: int = Field(default=120, ge=1, le=10000)
    RATE_LIMIT_WINDOW_SECONDS: int = Field(default=60, ge=1, le=3600)
    RATE_LIMIT_BUCKET_CAPACITY: int = Field(default=10000, ge=100, le=1000000)

    @field_validator("APP_ENV")
    @classmethod
    def validate_environment(cls, value: str) -> str:
        normalized = value.strip().lower()
        allowed = {"development", "testing", "production"}
        if normalized not in allowed:
            raise ValueError(f"APP_ENV must be one of: {', '.join(sorted(allowed))}")
        return normalized

    @field_validator("API_V1_PREFIX")
    @classmethod
    def validate_api_prefix(cls, value: str) -> str:
        normalized = value.rstrip("/")
        if not normalized.startswith("/"):
            raise ValueError("API_V1_PREFIX must start with '/'")
        return normalized

    @field_validator("LOG_LEVEL")
    @classmethod
    def validate_log_level(cls, value: str) -> str:
        normalized = value.upper()
        if normalized not in {"DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"}:
            raise ValueError("LOG_LEVEL is invalid")
        return normalized

    @field_validator("CORS_ORIGINS")
    @classmethod
    def prevent_production_wildcard(cls, value: list[str], info) -> list[str]:
        environment = info.data.get("APP_ENV", "development")
        if environment == "production" and "*" in value:
            raise ValueError("Wildcard CORS is not allowed in production")
        return value

    @field_validator("DATABASE_URL", "TEST_DATABASE_URL")
    @classmethod
    def validate_database_url(cls, value: str | None) -> str | None:
        if value and not value.startswith("postgresql+asyncpg://"):
            raise ValueError("Database URLs must use postgresql+asyncpg://")
        return value

    @field_validator("SUPABASE_URL")
    @classmethod
    def normalize_supabase_url(cls, value: str | None) -> str | None:
        return value.rstrip("/") if value else value

    @model_validator(mode="after")
    def derive_and_validate_security_settings(self) -> "Settings":
        if not self.DATABASE_URL and self.DB_HOST and self.DB_USER and self.DB_PASSWORD:
            user = quote(self.DB_USER, safe="")
            password = quote(self.DB_PASSWORD.get_secret_value(), safe="")
            self.DATABASE_URL = (
                f"postgresql+asyncpg://{user}:{password}"
                f"@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
            )
        if self.SUPABASE_URL:
            self.SUPABASE_JWT_ISSUER = self.SUPABASE_JWT_ISSUER or f"{self.SUPABASE_URL}/auth/v1"
            self.SUPABASE_JWKS_URL = (
                self.SUPABASE_JWKS_URL or f"{self.SUPABASE_URL}/auth/v1/.well-known/jwks.json"
            )
        if self.CLERK_ISSUER:
            self.CLERK_ISSUER = self.CLERK_ISSUER.rstrip("/")
            self.CLERK_JWKS_URL = (
                self.CLERK_JWKS_URL
                or f"{self.CLERK_ISSUER}/.well-known/jwks.json"
            )
        if self.APP_ENV == "production":
            required = {
                "DATABASE_URL": self.DATABASE_URL,
            }
            if self.AUTH_PROVIDER == "clerk":
                required.update(
                    CLERK_ISSUER=self.CLERK_ISSUER,
                    CLERK_JWKS_URL=self.CLERK_JWKS_URL,
                )
            else:
                required.update(
                    SUPABASE_URL=self.SUPABASE_URL,
                    SUPABASE_PUBLISHABLE_KEY=self.SUPABASE_PUBLISHABLE_KEY,
                    SUPABASE_JWT_ISSUER=self.SUPABASE_JWT_ISSUER,
                    SUPABASE_JWKS_URL=self.SUPABASE_JWKS_URL,
                )
            missing = [name for name, value in required.items() if not value]
            if missing:
                raise ValueError(f"Missing production configuration: {', '.join(missing)}")
        return self


@lru_cache
def get_settings() -> Settings:
    """Return one immutable-by-convention settings instance per process."""

    return Settings()
