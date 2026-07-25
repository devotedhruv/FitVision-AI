# Authentication Flow

1. Flutter initializes `supabase_flutter` with `SUPABASE_URL` and the public
   publishable key.
2. Registration and password login go directly to Supabase Auth.
3. Supabase persists and refreshes its session. FitVision does not copy refresh
   tokens into SharedPreferences.
4. Router state sends signed-out users to `/login`, unverified users to
   `/verify-email`, and verified users to `/dashboard`.
5. Dio reads the current access token immediately before each API request and
   adds `Authorization: Bearer <token>`.
6. FastAPI reads the JWT header, rejects algorithms outside the configured
   asymmetric allowlist, requires `kid`, fetches the matching public key through
   cached JWKS, and verifies signature, issuer, audience, expiry, `iat`, and
   `sub`.
7. The verified `sub` UUID is the only user identity accepted by repositories.

Legacy HS256 is intentionally unsupported. Migrate the Supabase project to
asymmetric signing before using this API; a shared JWT secret must never be
shipped to Flutter.
