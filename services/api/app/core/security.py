"""Isolated asymmetric Supabase JWT verification."""

import asyncio
from datetime import UTC, datetime
from typing import Any, Protocol
from uuid import UUID

import jwt
from jwt import PyJWKClient
from jwt.exceptions import InvalidTokenError, PyJWKClientError

from app.core.config import Settings
from app.core.exceptions import AuthenticationError
from app.schemas.auth import CurrentUserClaims


class SigningKeyProvider(Protocol):
    def get_signing_key_from_jwt(self, token: str): ...


class SupabaseJWTVerifier:
    """Verify issuer, audience, signature, algorithm and required claims."""

    def __init__(
        self,
        settings: Settings,
        key_provider: SigningKeyProvider | None = None,
    ):
        if not settings.SUPABASE_JWKS_URL or not settings.SUPABASE_JWT_ISSUER:
            raise RuntimeError("Supabase JWT issuer and JWKS URL must be configured")
        self.settings = settings
        self.key_provider = key_provider or PyJWKClient(
            settings.SUPABASE_JWKS_URL,
            cache_keys=True,
            lifespan=300,
        )

    async def verify(self, token: str) -> CurrentUserClaims:
        try:
            header = jwt.get_unverified_header(token)
            algorithm = header.get("alg")
            if algorithm not in self.settings.SUPABASE_JWT_ALGORITHMS:
                raise AuthenticationError("The access token uses an unsupported algorithm.")
            if not header.get("kid"):
                raise AuthenticationError("The access token is missing a key identifier.")
            if isinstance(self.key_provider, PyJWKClient):
                signing_key = await asyncio.to_thread(
                    self.key_provider.get_signing_key_from_jwt, token
                )
            else:
                signing_key = self.key_provider.get_signing_key_from_jwt(token)
            payload: dict[str, Any] = jwt.decode(
                token,
                signing_key.key,
                algorithms=list(self.settings.SUPABASE_JWT_ALGORITHMS),
                issuer=self.settings.SUPABASE_JWT_ISSUER,
                audience=self.settings.SUPABASE_JWT_AUDIENCE,
                options={"require": ["exp", "iat", "sub", "iss", "aud"]},
            )
            user_id = UUID(str(payload["sub"]))
            expires_at = datetime.fromtimestamp(payload["exp"], tz=UTC)
            return CurrentUserClaims(
                user_id=user_id,
                email=payload.get("email"),
                role=payload.get("role", "authenticated"),
                expires_at=expires_at,
            )
        except AuthenticationError:
            raise
        except (InvalidTokenError, PyJWKClientError, KeyError, TypeError, ValueError) as error:
            raise AuthenticationError("The access token is invalid or expired.") from error
