# Security checklist

- JWT signature, expiry, issuer, audience, required claims and allow-listed asymmetric algorithm verified.
- Ownership comes from verified `sub`; request `userId` is not authoritative.
- RLS enabled for profiles, workouts, reps, runs and points; anonymous role gets no policy.
- API validation returns sanitized errors; ORM queries are parameterized.
- Configurable 429 limiter and request correlation IDs are tested.
- Mobile contains only publishable Supabase configuration; no service-role credential belongs there.
- Tracked credential/private-video scanner runs in CI without printing matched values.
- Individual workout/run deletion is owned and cascade-safe.
- Shared rate-limit backend, live RLS verification, account identity deletion and device-at-rest encryption remain explicit deployment/product work.
