# Security Decisions

- Supabase Auth owns password storage, confirmation, session refresh, and logout.
- FastAPI supports asymmetric ES256/RS256-family algorithms only, configured by
  allowlist. The token cannot choose an unapproved algorithm.
- JWKS keys are cached for five minutes and PyJWT refreshes the key set when an
  unknown rotated `kid` is encountered.
- API authorization derives UUID ownership only from verified `sub`.
- Every owned repository query includes both resource identity and `user_id`.
- RLS repeats ownership checks with `(select auth.uid())` as defense in depth.
- Exercise definitions have authenticated read-only RLS; no write API exists.
- Tokens and secrets are excluded from logs and safe error envelopes.
- Production rejects incomplete Supabase/database configuration and wildcard
  credentialed CORS.
- Flutter receives only the Supabase URL and publishable key. Service-role keys,
  shared JWT secrets, and database URLs are prohibited.

Supabase Auth account deletion is deferred because it requires a privileged,
audited server-only workflow that Phase 3 does not otherwise need.
