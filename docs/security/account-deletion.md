# Account and history deletion

Individual workout and run deletion endpoints enforce JWT ownership and database cascades. The Settings history-deletion workflow explicitly confirms scope, calls the authenticated idempotent `DELETE /api/v1/users/me/data` transaction, then clears only that user's local rows and profile cache. Server profile deletion cascades workouts, reps, runs and route points.

The final privileged Supabase Auth identity-deletion workflow is still separate from history deletion and is **not implemented**. It must run on the backend using privileged credentials and a recoverable cross-service saga; service-role credentials must never be added to Flutter.
