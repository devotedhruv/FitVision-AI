"""Isolated asymmetric Supabase JWT verification."""

import asyncio
from datetime import UTC, datetime
from typing import Any, Protocol
from uuid import UUID, uuid5

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
                identity_provider="supabase",
                provider_subject=str(payload["sub"]),
            )
        except AuthenticationError:
            raise
        except (InvalidTokenError, PyJWKClientError, KeyError, TypeError, ValueError) as error:
            raise AuthenticationError("The access token is invalid or expired.") from error


class ClerkJWTVerifier:
    """Verify Clerk session JWTs and expose a stable internal UUID boundary."""

    _namespace = UUID("5cd47535-0a73-4b48-a600-e790dcca62a2")

    def __init__(
        self,
        settings: Settings,
        key_provider: SigningKeyProvider | None = None,
    ):
        if not settings.CLERK_ISSUER or not settings.CLERK_JWKS_URL:
            raise RuntimeError("Clerk issuer and JWKS URL must be configured")
        self.settings = settings
        self.key_provider = key_provider or PyJWKClient(
            settings.CLERK_JWKS_URL,
            cache_keys=True,
            lifespan=300,
        )

    async def verify(self, token: str) -> CurrentUserClaims:
        try:
            header = jwt.get_unverified_header(token)
            if header.get("alg") != "RS256" or not header.get("kid"):
                raise AuthenticationError("The access token header is invalid.")
            if isinstance(self.key_provider, PyJWKClient):
                signing_key = await asyncio.to_thread(
                    self.key_provider.get_signing_key_from_jwt, token
                )
            else:
                signing_key = self.key_provider.get_signing_key_from_jwt(token)
            options = {
                "require": ["exp", "nbf", "sub", "iss"],
                "verify_aud": bool(self.settings.CLERK_AUDIENCE),
            }
            payload: dict[str, Any] = jwt.decode(
                token,
                signing_key.key,
                algorithms=["RS256"],
                issuer=self.settings.CLERK_ISSUER,
                audience=self.settings.CLERK_AUDIENCE,
                options=options,
            )
            subject = str(payload["sub"])
            if not subject.startswith("user_"):
                raise AuthenticationError("The access token subject is invalid.")
            authorized_parties = self.settings.CLERK_AUTHORIZED_PARTIES
            if authorized_parties and payload.get("azp") not in authorized_parties:
                raise AuthenticationError("The access token authorized party is invalid.")
            return CurrentUserClaims(
                user_id=uuid5(self._namespace, subject),
                email=payload.get("email"),
                expires_at=datetime.fromtimestamp(payload["exp"], tz=UTC),
                identity_provider="clerk",
                provider_subject=subject,
            )
        except AuthenticationError:
            raise
        except (InvalidTokenError, PyJWKClientError, KeyError, TypeError, ValueError) as error:
            raise AuthenticationError("The access token is invalid or expired.") from error
