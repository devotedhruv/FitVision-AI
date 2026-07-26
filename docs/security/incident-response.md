# Incident response

1. Contain: disable affected endpoint/key, preserve sanitized request IDs and timestamps, never copy tokens/routes into tickets.
2. Assess: impacted users, tables, time window, RLS/API path and whether camera/GPS data was exposed.
3. Remediate: rotate credentials/signing keys, repair policy/authorization, revoke sessions and patch clients as applicable.
4. Notify: follow legal/product obligations using factual scope and user actions.
5. Recover: verify two-user ownership, deletion, idempotency and audit logs before restoration.
6. Learn: add a regression test and update this threat model without retaining personal payloads.
