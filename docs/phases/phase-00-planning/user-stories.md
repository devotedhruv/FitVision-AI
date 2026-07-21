# Prioritized User Stories

Priorities use MoSCoW: **Must** is required for the MVP, **Should** is important but deferrable, and **Could** is an optional enhancement. “Local data layer” and “sync service” refer to planned later-phase components.

| ID | User role | Story | Priority | Dependencies | Acceptance summary |
|---|---|---|---|---|---|
| US-AUTH-001 | Visitor | As a visitor, I want to register so that my activity belongs to a private account. | Must | Supabase Auth, network | Valid details create an account; invalid/duplicate details produce a safe error. |
| US-AUTH-002 | Registered user | As a user, I want to log in and restore my session securely. | Must | US-AUTH-001 | Valid credentials enter the app; failures reveal no sensitive account detail. |
| US-AUTH-003 | Registered user | As a user, I want to log out so that another device user cannot access my cloud data. | Must | US-AUTH-002 | Tokens are cleared and protected screens require authentication. |
| US-ONBOARD-001 | New user | As a new user, I want to set my display name and unit preference. | Must | US-AUTH-001 | Profile persists and distance/pace units follow the choice. |
| US-PRIVACY-001 | Exerciser | As an exerciser, I want a contextual camera-permission request so I understand why it is needed. | Must | OS permission API | The request follows an explanation and denial offers settings/manual recovery. |
| US-PRIVACY-002 | Runner | As a runner, I want location requested only when needed. | Must | OS location API | Run cannot start without required permission; denial does not block strength features. |
| US-PRIVACY-003 | Registered user | As a user, I want to delete my account and activity data. | Must | Auth, local DB, API | Confirmation triggers local removal and authenticated cloud-deletion workflow. |
| US-EXERCISE-001 | Exerciser | As an exerciser, I want to choose a supported exercise explicitly. | Must | Exercise catalogue | MVP/extended availability is clear and only enabled choices can start. |
| US-EXERCISE-002 | Exerciser | As an exerciser, I want camera-position instructions before starting. | Must | US-EXERCISE-001 | View, framing, lighting, and safety guidance match the exercise. |
| US-EXERCISE-003 | Exerciser | As an exerciser, I want live pose detection so that the app can assess movement. | Must | Camera permission, native pose bridge | Visible landmarks are processed locally and low-confidence frames are excluded. |
| US-EXERCISE-004 | Exerciser | As an exerciser, I want automatic valid-rep counting. | Must | US-EXERCISE-003, exercise rules | Only a full ordered state transition increments once. |
| US-EXERCISE-005 | Exerciser | As an exerciser, I want immediate, concise form feedback. | Must | US-EXERCISE-003 | Applicable rules display without claiming medical judgment and clear when resolved. |
| US-EXERCISE-006 | Exerciser | As an exerciser, I want to pause, resume, and end a workout. | Must | Active session | Paused frames do not count; resume continues; end produces results once. |
| US-EXERCISE-007 | Exerciser | As an exerciser, I want a workout result showing counts, duration, and form summary. | Must | US-EXERCISE-006 | Result matches persisted events and identifies the rule version. |
| US-EXERCISE-008 | Exerciser | As an exerciser, I want a clear response when no reliable pose is visible. | Must | Pose confidence | Counting stops and repositioning guidance appears without adding reps. |
| US-RUN-001 | Runner | As a runner, I want GPS tracking of duration, distance, route, speed, and pace. | Must | Location permission/GPS | Live and final metrics derive from accepted points and elapsed active time. |
| US-RUN-002 | Runner | As a runner, I want tracking to continue during allowed background use. | Must | OS background-location policy | Active tracking continues with required foreground indication or explains OS restriction. |
| US-RUN-003 | Runner | As a runner, I want to pause, resume, and end a run. | Must | US-RUN-001 | Paused movement/time is excluded and finish saves one result. |
| US-RUN-004 | Runner | As a runner, I want GPS-unavailable and inaccurate-point handling. | Must | Location service | The app flags degraded tracking and rejects/flags unacceptable points. |
| US-HISTORY-001 | Registered user | As a user, I want workouts and runs saved offline before sync. | Must | Local data layer | A finished session remains available after restart without connectivity. |
| US-HISTORY-002 | Registered user | As a user, I want synchronized strength and running history. | Must | API, sync service | History is chronological, user-scoped, and reports pending/failed sync safely. |
| US-SYNC-001 | Registered user | As a user, I want pending data synchronized after connectivity returns. | Must | Local queue, API | Retries are idempotent and never create duplicate sessions. |
| US-SYNC-002 | Registered user | As a user, I want understandable network-error behavior. | Must | Local queue | A network failure preserves data, indicates pending state, and permits retry. |
| US-ANALYTICS-001 | Registered user | As a user, I want progress summaries for strength and running. | Must | Sufficient history | Date-range totals and trends use only the signed-in user's stored sessions. |
| US-ANALYTICS-002 | Registered user | As a user, I want personalized rule-based insights. | Should | US-ANALYTICS-001 | Explainable insights identify their input period and avoid medical claims. |
| US-SETTINGS-001 | Registered user | As a user, I want metric or imperial units. | Must | Profile/local settings | All displayed running values update consistently without changing stored base values. |
| US-ACCESS-001 | User | As a user, I want readable controls and screen-reader labels. | Should | UI design system | Core flows are operable with scalable text and labeled controls. |
| US-EXERCISE-009 | Exerciser | As an exerciser, I want lunge and plank monitoring after MVP validation. | Could | MVP engine, calibrated rules | Each follows its documented state model and limitations. |

## Traceability

Detailed implementation obligations are mapped by story ID in [Functional Requirements](functional-requirements.md), with behavioral examples in [Acceptance Criteria](acceptance-criteria.md).

