# Idempotency

The mobile-generated workout UUID never changes and is sent as
`client_session_id`. PostgreSQL enforces unique `(user_id, client_session_id)`.
The service returns the existing owned workout on repeat requests and catches
the database uniqueness race between concurrent retries.

Every local rep also has a UUID and unique `(workout_local_id,
sequence_number)`. The API accepts it as `client_event_id`; PostgreSQL enforces
unique `(workout_session_id, client_event_id)` and retains the existing unique
rep-number constraint. Ownership comes only from verified bearer claims, never
from request payloads.

Thus a timeout after server commit can be retried with identical IDs without
creating a second workout or rep.
