# Threat model

| Threat / asset | Risk | Mitigation and verification | Residual limitation |
|---|---|---|---|
| Token theft / auth tokens | account access | HTTPS, secure Supabase session storage, verified asymmetric JWT claims; invalid-signature/issuer/audience/expiry/algorithm tests | compromised device/session remains possible |
| BOLA / histories and routes | cross-user private data | user ID derived from JWT, ownership-scoped API queries, RLS parent checks | live two-user Supabase policy test pending |
| Replay / duplicate uploads | duplicate sessions/points | client UUID constraints and transactional idempotency tests | malicious traffic still needs gateway controls |
| Injection / database | data disclosure/corruption | Pydantic models and SQLAlchemy parameterization | dependency vulnerabilities require continuous audit |
| Excessive API use | cost/availability | configurable process limiter with 429/Retry-After test | multi-instance shared limiter required |
| Sensitive logs / camera/GPS/tokens | privacy loss | no raw-frame/route logging; correlation IDs contain no credentials; tracked-file scanner | crash-provider runtime configuration not verified |
| Local SQLite access | history/route exposure on compromised phone | Android app sandbox; user-filtered reads | database-at-rest encryption not implemented |
| Deletion abuse | irreversible loss | authenticated ownership, confirmation, cascades, idempotent DELETE | full Supabase Auth account deletion is backend-admin work |
| CORS/secrets/RLS misconfiguration | broad access | production wildcard rejection, env secrets, RLS SQL audit | deployment configuration must be verified separately |
