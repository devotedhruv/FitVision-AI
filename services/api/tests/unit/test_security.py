"""JWT verification is local, deterministic, and never contacts Supabase."""

from datetime import UTC, datetime, timedelta
from types import SimpleNamespace
from uuid import uuid4

import jwt
import pytest
from cryptography.hazmat.primitives.asymmetric import rsa

from app.core.config import Settings
from app.core.exceptions import AuthenticationError
from app.core.security import SupabaseJWTVerifier

ISSUER = "https://project.supabase.co/auth/v1"
AUDIENCE = "authenticated"


class StaticKeyProvider:
    def __init__(self, public_key):
        self.public_key = public_key

    def get_signing_key_from_jwt(self, _token: str):
        return SimpleNamespace(key=self.public_key)


@pytest.fixture(scope="module")
def keys():
    private = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    other = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    return private, private.public_key(), other


@pytest.fixture
def settings():
    return Settings(
        APP_ENV="testing",
        SUPABASE_URL="https://project.supabase.co",
        SUPABASE_JWT_ALGORITHMS=["RS256"],
    )


def token(private_key, **overrides) -> str:
    now = datetime.now(UTC)
    payload = {
        "sub": str(uuid4()),
        "email": "athlete@example.com",
        "role": "authenticated",
        "iss": ISSUER,
        "aud": AUDIENCE,
        "iat": now,
        "exp": now + timedelta(minutes=10),
    }
    payload.update(overrides)
    return jwt.encode(payload, private_key, algorithm="RS256", headers={"kid": "test-key"})


@pytest.mark.asyncio
async def test_valid_token_is_accepted(settings, keys):
    private, public, _ = keys
    claims = await SupabaseJWTVerifier(settings, StaticKeyProvider(public)).verify(token(private))
    assert claims.email == "athlete@example.com"
    assert claims.role == "authenticated"


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "overrides",
    [
        {"exp": datetime.now(UTC) - timedelta(seconds=1)},
        {"iss": "https://wrong.example/auth/v1"},
        {"aud": "wrong-audience"},
    ],
)
async def test_invalid_registered_claims_are_rejected(settings, keys, overrides):
    private, public, _ = keys
    with pytest.raises(AuthenticationError):
        await SupabaseJWTVerifier(settings, StaticKeyProvider(public)).verify(
            token(private, **overrides)
        )


@pytest.mark.asyncio
async def test_invalid_signature_is_rejected(settings, keys):
    _private, public, other = keys
    with pytest.raises(AuthenticationError):
        await SupabaseJWTVerifier(settings, StaticKeyProvider(public)).verify(token(other))


@pytest.mark.asyncio
async def test_malformed_and_unsupported_tokens_are_rejected(settings, keys):
    _private, public, _other = keys
    verifier = SupabaseJWTVerifier(settings, StaticKeyProvider(public))
    with pytest.raises(AuthenticationError):
        await verifier.verify("not-a-token")
    unsupported = jwt.encode(
        {"sub": str(uuid4())},
        "not-used-but-long-enough-for-hs256-tests",
        algorithm="HS256",
        headers={"kid": "legacy"},
    )
    with pytest.raises(AuthenticationError):
        await verifier.verify(unsupported)
