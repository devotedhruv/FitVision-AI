# Coverage matrix

| Area | Automated evidence | Remaining evidence |
|---|---|---|
| Auth/JWT | signature, expiry, issuer, audience, algorithm and malformed-token unit tests | live key rotation |
| Exercise | 26 deterministic geometry/filter/analyzer tests | consented holdout recordings |
| Workout/storage/sync | lifecycle, Drift, idempotency and retry tests | long interruption soak |
| Running | calculations, GPS filter, database and service mapping tests | measured outdoor routes |
| History/analytics | filter, timezone, aggregation, trend and insight tests | large-dataset query profile |
| API | 36 local tests including request hardening/deletion/RLS contract; external DB suite is opt-in | two-user RLS against Supabase |
| Privacy | tracked-file credential/media scanner and code inspection | runtime crash-report inspection |
