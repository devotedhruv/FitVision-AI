# Acceptance Criteria and Phase 0 Definition of Done

Criteria identify the principal requirements they validate; the complete verification matrix will be expanded into test cases during implementation.

## Authentication and Onboarding

### AC-AUTH-001 — Registration and login (`FR-AUTH-001`–`004`)

- **Given** valid registration details and connectivity, **when** the visitor submits registration, **then** an account is created or verification guidance is shown without exposing secrets.
- **Given** valid credentials, **when** the user logs in, **then** Home opens for that identity and a valid session can be restored after restart.
- **Given** invalid credentials, **when** login fails, **then** a generic safe error is shown and no protected data appears.
- **Given** a signed-in user, **when** logout completes, **then** protected routes require authentication and local tokens are cleared.

### AC-ONBOARD-001 — Profile and units (`FR-PROFILE-001`, `FR-SETTINGS-001`–`002`)

- **Given** a new authenticated user, **when** onboarding is completed, **then** display name and metric/imperial choice persist locally and later synchronize.
- **Given** stored canonical measurements, **when** units change, **then** displayed distance, speed, and pace convert consistently without rewriting measurements.

## Permissions

### AC-PERM-001 — Camera (`FR-PERM-001`–`002`)

- **Given** camera permission is undecided, **when** an exercise requiring pose starts, **then** purpose guidance appears before the OS request.
- **Given** permission is denied, **when** the user returns, **then** camera workout start is blocked with retry/settings guidance while running/history remain available as applicable.

### AC-PERM-002 — Location (`FR-PERM-003`–`004`)

- **Given** location permission is absent, **when** a run is requested, **then** contextual guidance and the minimum required OS request appear.
- **Given** permission is denied, **then** the run does not start, no points are collected, and strength workout access remains unaffected.
- **Given** background tracking needs additional permission or a foreground service, **then** the app explains the requirement and accurately reports restricted behavior.

## Pose Detection and Feedback

### AC-POSE-001 — Local pose pipeline (`FR-POSE-001`–`004`)

- **Given** permission and a supported visible pose, **when** camera frames arrive, **then** timestamped landmarks/confidence are produced on device and raw frames are absent from backend traffic.
- **Given** a required landmark below configured confidence, **when** that frame is evaluated, **then** it does not advance a rep state or form score.

### AC-POSE-002 — Lost landmarks (`FR-POSE-005`, `FR-ERROR-001`)

- **Given** an active exercise, **when** required landmarks remain lost beyond the configured interval, **then** evaluation pauses, the count remains unchanged, and repositioning guidance appears.
- **Given** confidence returns, **then** evaluation resumes only from a safe/re-armed state; lost frames are not retroactively counted.

### AC-FORM-001 — Rule-based feedback (`FR-FORM-001`–`004`)

- **Given** an eligible frame/state that violates a configured observable rule, **then** an actionable, prioritized cue appears within the engineering latency target.
- **Given** the rule is no longer violated, **then** stale feedback clears according to its debounce policy.
- Feedback and results contain no injury/medical diagnosis, and persisted issues reference the rule version rather than raw images.

## Exercise Counting

### AC-REP-001 — Squat (`FR-REP-001`–`004`)

- **Given** a calibrated supported side view, **when** landmarks traverse `READY → DESCENDING → BOTTOM → ASCENDING → COMPLETE`, **then** the valid count increments exactly once.
- Holding BOTTOM or COMPLETE, boundary jitter, or repeating identical frames does not increment again until the machine validly re-arms.

### AC-REP-002 — Biceps curl (`FR-REP-001`–`004`)

- **Given** the working arm is confidently visible, **when** it traverses `EXTENDED → CURLING → CONTRACTED → LOWERING → COMPLETE`, **then** the valid count increments exactly once.
- Remaining contracted or making an incomplete lower does not create an additional valid rep.

### AC-REP-003 — Push-up (`FR-REP-001`–`004`)

- **Given** the supported side view, **when** landmarks traverse `TOP → LOWERING → BOTTOM → RISING → COMPLETE`, **then** the valid count increments exactly once.
- Remaining at the bottom/top or skipping the calibrated bottom does not create a valid rep.

### AC-REP-004 — Invalid/partial movement (`FR-REP-003`, `FR-FORM-004`)

- **Given** a transition reverses early, skips a required state, occurs while paused, or relies on low-confidence frames, **then** valid reps do not increment.
- **Given** the product records invalid attempts, **then** each attempt is stored once with a structured reason and does not inflate valid reps; `total_reps = valid_reps + invalid_reps` under the selected event policy.

## Workout Session

### AC-WORKOUT-001 — Controls and completion (`FR-WORKOUT-001`–`003`)

- **Given** setup is valid, **when** countdown finishes, **then** exactly one active workout begins.
- **Given** an active workout, **when** paused, **then** duration, counting, and form evaluation stop; **when** resumed, the same session continues safely.
- **When** finish is confirmed, **then** one result displays matching exercise, active duration, counts, form summary, timestamps, and rule version.

## Offline Storage and Synchronization

### AC-SYNC-001 — Local-first save (`FR-SYNC-001`, `NFR-RELIABILITY-002`)

- **Given** no network, **when** a workout or run finishes, **then** its result is committed locally, visible after process/device restart, and marked pending.
- A failed local commit is reported and is not falsely presented as a saved/synchronized result.

### AC-SYNC-002 — Retry and duplicate prevention (`FR-SYNC-002`–`005`)

- **Given** a pending session, **when** connectivity returns or retry is selected, **then** the same stable client session ID is sent and status changes only after an acknowledged response.
- **Given** the response is lost and the request is retried, **then** the server contains one logical session and the local item resolves to that record.
- **Given** another network failure, **then** the item remains locally readable and retryable without blocking new sessions.

## GPS Running

### AC-RUN-001 — Metrics and distance (`FR-RUN-001`–`004`)

- **Given** an active run and accepted ordered GPS points, **then** duration, route, distance, current/average speed, and current/average pace update from active time and accepted points.
- **Given** a point exceeds the configured accuracy/jump policy, **then** it is rejected or visibly flagged and is not silently included in trusted distance.
- Final distance can be reproduced from the stored accepted point sequence within defined rounding tolerance.

### AC-RUN-002 — Pause/resume/background/GPS failure (`FR-RUN-005`–`007`)

- **Given** an active run, **when** paused, **then** paused time and movement do not affect active metrics; **when** resumed, new accepted points continue the same session without bridging an implausible pause gap.
- **Given** the app backgrounds on a supported configuration, **then** tracking continues with the required persistent OS indication.
- **Given** GPS becomes unavailable, **then** the existing session remains intact, degraded status appears, and no synthetic points are created.
- **When** finish is confirmed, **then** exactly one locally saved running result is produced.

## History and Analytics

### AC-HISTORY-001 — History (`FR-HISTORY-001`–`002`)

- **Given** stored sessions for the signed-in user, **when** History opens, **then** strength and running sessions appear newest first with type, date, key result, and sync state.
- **When** a session is selected, **then** its persisted details appear and a run route is shown only when point data exists.

### AC-ANALYTICS-001 — Analytics (`FR-ANALYTICS-001`–`003`)

- **Given** completed sessions in a selected date range, **then** displayed totals/trends match a direct calculation from those sessions.
- Empty data produces an informative empty state, not invented values.
- Insights name their input period/basis, remain rule-based, and contain no medical or calorie-restriction advice.

## Privacy, Isolation, and Deletion

### AC-PRIVACY-001 — Data isolation (`FR-PROFILE-002`, `FR-PRIVACY-001`)

- **Given** users A and B, **when** A requests or manipulates B's record identifier, **then** the server denies the operation and B's data is not disclosed.
- Local account switching does not display the prior user's cached activity to the new user.

### AC-PRIVACY-002 — Deletion (`FR-PRIVACY-002`–`003`)

- **Given** an authenticated user confirms deletion, **then** local profile/activity is removed and an authenticated cloud-deletion request is made.
- **Given** cloud deletion cannot complete, **then** the UI says deletion is pending/failed, offers recovery, and does not falsely claim full deletion.
- **Given** deletion succeeds, **then** subsequent authenticated reads return no deleted user activity, subject only to explicitly disclosed operational/legal retention.

## Error States

### AC-ERROR-001 — Safe recovery (`FR-ERROR-001`–`003`)

- Camera initialization, detector initialization, storage, GPS, authentication, and network failures each provide a non-sensitive message and relevant retry/exit path.
- No error log contains password, token, raw frame, or precise route point by default.
- No recoverable error erases an already committed session or creates a rep/route point without valid evidence.

## Phase 0 Definition of Done

- [x] All eight required Phase 0 Markdown documents exist and are non-empty.
- [x] Functional/non-functional requirements and user stories have unique identifiers.
- [x] User stories map to functional requirements through the “Related story” column.
- [x] Acceptance criteria map to all major requirements/modules.
- [x] MVP and extended exercise scope are clearly separated.
- [x] Assumptions, constraints, limitations, and risks are documented.
- [x] System architecture, user flow, and conceptual ERD PNGs exist and are readable.
- [x] Root README links to every Phase 0 document and previews every diagram.
- [x] The Phase 0 work created no Phase 1 application, API, migration, production, or dependency code. Later Phase 1 artifacts now present in the repository are outside this Phase 0 deliverable and were preserved.
