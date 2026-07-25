-- Apply in Supabase only after the Alembic schema migration.
-- The API also scopes every ownership query; these policies are defense in depth.
alter table public.profiles enable row level security;
alter table public.exercise_definitions enable row level security;
alter table public.workout_sessions enable row level security;
alter table public.rep_events enable row level security;
alter table public.running_sessions enable row level security;
alter table public.running_points enable row level security;

create policy "profiles_select_own" on public.profiles for select
  to authenticated using ((select auth.uid()) = id);
create policy "profiles_update_own" on public.profiles for update
  to authenticated using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);
create policy "profiles_insert_own" on public.profiles for insert
  to authenticated with check ((select auth.uid()) = id);

create policy "active_exercises_read" on public.exercise_definitions for select
  to authenticated using (is_active);

create policy "workouts_select_own" on public.workout_sessions for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "workouts_insert_own" on public.workout_sessions for insert
  to authenticated with check ((select auth.uid()) = user_id);
create policy "workouts_update_own" on public.workout_sessions for update
  to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "workouts_delete_own" on public.workout_sessions for delete
  to authenticated using ((select auth.uid()) = user_id);

create policy "rep_events_select_owned" on public.rep_events for select
  to authenticated using (exists (
    select 1 from public.workout_sessions workout
    where workout.id = workout_session_id
      and workout.user_id = (select auth.uid())
  ));
create policy "rep_events_insert_owned" on public.rep_events for insert
  to authenticated with check (exists (
    select 1 from public.workout_sessions workout
    where workout.id = workout_session_id
      and workout.user_id = (select auth.uid())
  ));
create policy "rep_events_update_owned" on public.rep_events for update
  to authenticated using (exists (
    select 1 from public.workout_sessions workout
    where workout.id = workout_session_id
      and workout.user_id = (select auth.uid())
  ));
create policy "rep_events_delete_owned" on public.rep_events for delete
  to authenticated using (exists (
    select 1 from public.workout_sessions workout
    where workout.id = workout_session_id
      and workout.user_id = (select auth.uid())
  ));

create policy "runs_select_own" on public.running_sessions for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "runs_insert_own" on public.running_sessions for insert
  to authenticated with check ((select auth.uid()) = user_id);
create policy "runs_update_own" on public.running_sessions for update
  to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "runs_delete_own" on public.running_sessions for delete
  to authenticated using ((select auth.uid()) = user_id);

create policy "running_points_select_owned" on public.running_points for select
  to authenticated using (exists (
    select 1 from public.running_sessions run
    where run.id = running_session_id and run.user_id = (select auth.uid())
  ));
create policy "running_points_insert_owned" on public.running_points for insert
  to authenticated with check (exists (
    select 1 from public.running_sessions run
    where run.id = running_session_id and run.user_id = (select auth.uid())
  ));
create policy "running_points_update_owned" on public.running_points for update
  to authenticated using (exists (
    select 1 from public.running_sessions run
    where run.id = running_session_id and run.user_id = (select auth.uid())
  ));
create policy "running_points_delete_owned" on public.running_points for delete
  to authenticated using (exists (
    select 1 from public.running_sessions run
    where run.id = running_session_id and run.user_id = (select auth.uid())
  ));
