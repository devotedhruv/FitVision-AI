# API Contract

All resource endpoints below require a valid bearer token.

| Method | Path | Purpose |
|---|---|---|
| GET | `/api/v1/auth/session` | Safe verified claims |
| GET/PATCH | `/api/v1/users/me` | Upsert/read or update own profile |
| GET | `/api/v1/exercises` | Active catalogue; optional `mvp_only` |
| GET | `/api/v1/exercises/{slug}` | One active definition |
| POST/GET | `/api/v1/workouts` | Idempotent create or paginated own list |
| GET/DELETE | `/api/v1/workouts/{id}` | Read or delete owned workout |
| POST/GET | `/api/v1/runs` | Idempotent create or paginated own list |
| GET/DELETE | `/api/v1/runs/{id}` | Read or delete owned run |
| GET | `/api/v1/analytics/summary` | Own aggregate totals |

`GET /api/v1/health` is public process health. `GET /api/v1/readiness` checks
database connectivity without disclosing connection details.

Paginated responses contain `items`, `total`, `limit`, and `offset`. Expected
errors use:

```json
{"error":{"code":"RESOURCE_NOT_FOUND","message":"The requested resource was not found."}}
```

Create payloads never accept `user_id`. Workouts accept up to 500 ordered,
unique rep events; runs accept up to 5,000 contiguous points beginning at
sequence zero.
