# Project Scope

## Objective

Plan an Android-first application that automatically monitors a defined set of exercises, records GPS runs, persists sessions offline, synchronizes structured records, and presents history and rule-based progress insights while protecting camera privacy.

## Delivery Scope

| Stage | Included capability |
|---|---|
| MVP | Authentication/profile, permissions, squats, biceps curls, push-ups, rep counting, initial form cues, workout controls/results, GPS running, local-first storage, idempotent sync, history, basic analytics/settings/privacy controls |
| Extended | Lunges and planks after MVP calibration and validation; refined exercise rules and insights |

“Extended” means planned final-project scope after the MVP, not an unbounded future feature set.

## In-Scope Features

- Registration, login, logout, profile setup, and metric/imperial preference.
- Contextual camera and location permission onboarding with denied-state recovery.
- User-selected exercise and view-specific camera guidance.
- On-device pose landmark detection, confidence filtering, state-machine rep counting, and rule-based feedback.
- Pause, resume, finish, results, and persistent strength-session history.
- Outdoor run duration, distance, current/average speed, current/average pace, route, controls, and history.
- Local-first SQLite/Drift persistence and a retryable, duplicate-safe synchronization queue.
- FastAPI business APIs, Supabase Auth, PostgreSQL/Supabase persistence, and rule-based analytics in later phases.
- User-scoped history, deletion, error handling, and diagnostic events that exclude raw frames and precise routes unless necessary and consented.

## Out of Scope for the First Version

- Nutrition planning or calorie-restriction recommendations.
- Medical diagnosis, injury diagnosis, rehabilitation prescription, or emergency monitoring.
- Live personal-trainer video calls.
- Social-media feeds, sharing, challenges, or messaging.
- Wearable integration.
- Fully automatic recognition of every possible exercise.
- Uploading raw workout video or raw camera frames to the backend.
- iOS, web, and desktop clients as supported release targets.
- Multi-person pose tracking, gym-equipment recognition, and payment functionality.

## Target Platform

Android-first mobile devices. The planned Flutter architecture may enable later platforms, but Phase 0 makes no compatibility commitment beyond a supported Android matrix to be defined and tested in Phase 1.

## Supported Exercise Conditions

One unobstructed user; stable phone; full relevant body region in frame; exercise-specific front or side view; adequate, even lighting; ordinary workout clothing that does not hide joints; sufficient space; and no moving bystanders dominating the frame. See [Supported Exercises](supported-exercises.md).

## User Roles

| Role | Responsibility and access |
|---|---|
| Registered exerciser | Own profile, run workouts, view/delete own data, manage preferences |
| Project administrator (operational) | Maintain exercise/rule versions and service health; no routine access to raw camera data, which is not uploaded |

Anonymous cloud history and coach/social roles are not part of the first version.

## External Systems

- Supabase Auth for identity.
- FastAPI REST service for authorized business operations and synchronization.
- PostgreSQL through Supabase for durable cloud records.
- Android camera and MediaPipe native integration for on-device pose processing.
- Android location/background services and a maps provider for route capture/display.
- GitHub Actions and Docker for later CI/deployment.

## Technical Boundaries

Flutter/Dart owns UI, navigation, presentation state, use cases, and local data orchestration. Kotlin connected through Pigeon or typed platform channels owns the native MediaPipe bridge. Exercise rules consume landmarks and confidence values, not images. SQLite/Drift is the local source during active/offline sessions. FastAPI validates ownership and applies business logic; PostgreSQL stores synchronized records. Exact provider versions, schemas, and deployment topology are Phase 1 decisions.

## Privacy Boundaries

Pose inference occurs on device. Raw camera frames remain in volatile processing memory and are not uploaded by default. Only structured session summaries, rep/form events, profile data, and running route data are synchronized. Precise location is collected only for an active run with permission. Access is user-scoped, production transport uses HTTPS, and deletion covers local and cloud records subject to documented operational retention.

## Future Enhancements

After the defined project scope: iOS support, optional wearable input, additional calibrated exercises, richer accessibility, privacy-preserving model personalization, export controls, and clinician- or coach-reviewed rule libraries. These are candidates, not commitments.

