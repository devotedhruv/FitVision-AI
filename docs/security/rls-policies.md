# RLS policy audit

`services/api/migrations/supabase/001_enable_rls_and_policies.sql` enables RLS on profiles, exercise definitions, workout sessions, rep events, running sessions and running points. Parent rows compare `auth.uid()` with `user_id`; child policies use an ownership `exists` query through the parent. Profiles permit own select/insert/update; workout/run parents permit own CRUD; exercise definitions are read-only when active. No policy is granted to anonymous users.

Measured status: SQL inspection passed. NOT VERIFIED: applying these policies against a live isolated Supabase database with two users and anonymous access. This is a release gate, not inferred from API ownership tests.
