# Functional Requirements

Verification methods: **Test** (automated/manual behavior test), **Inspection** (code/config/design review), **Analysis** (calculation or record comparison), and **Demonstration** (end-to-end observed flow).

## 1. Authentication

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-AUTH-001 | The system shall register a user through Supabase Auth after validating required input. | Must | US-AUTH-001 | Test |
| FR-AUTH-002 | The system shall authenticate valid credentials and restore a valid persisted session. | Must | US-AUTH-002 | Test |
| FR-AUTH-003 | The system shall reject invalid authentication without disclosing whether an account exists. | Must | US-AUTH-001, US-AUTH-002 | Test |
| FR-AUTH-004 | Logout shall revoke or clear local authentication state and return to an unauthenticated route. | Must | US-AUTH-003 | Test |

## 2. Profile

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-PROFILE-001 | The system shall store the authenticated user's display name and preferred units locally and synchronize them when online. | Must | US-ONBOARD-001 | Test |
| FR-PROFILE-002 | Each profile operation shall be scoped to the authenticated user identifier. | Must | US-ONBOARD-001, US-PRIVACY-003 | Test, Inspection |

## 3. Permissions

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-PERM-001 | The system shall explain camera use before requesting camera permission. | Must | US-PRIVACY-001 | Demonstration |
| FR-PERM-002 | Camera denial shall prevent pose capture, preserve access to non-camera screens, and offer retry or system-settings guidance. | Must | US-PRIVACY-001 | Test |
| FR-PERM-003 | The system shall request location permission in the running context and shall not require it for strength workouts. | Must | US-PRIVACY-002 | Test |
| FR-PERM-004 | The system shall request background-location capability only when required by the selected OS implementation and explain its purpose. | Must | US-RUN-002 | Inspection, Test |

## 4. Exercise Selection

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-SELECT-001 | The system shall list the supported exercises and identify unavailable extended exercises. | Must | US-EXERCISE-001 | Test |
| FR-SELECT-002 | Before a workout, the system shall show exercise-specific view, framing, lighting, and space instructions. | Must | US-EXERCISE-002 | Inspection, Demonstration |

## 5. Camera and Pose Detection

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-POSE-001 | Pose inference shall run on the device through the native MediaPipe integration. | Must | US-EXERCISE-003 | Inspection, Test |
| FR-POSE-002 | Raw camera frames shall not be uploaded by default. | Must | US-EXERCISE-003, US-PRIVACY-001 | Inspection, Network test |
| FR-POSE-003 | The detector shall return timestamped landmarks and confidence values to the exercise engine. | Must | US-EXERCISE-003 | Interface test |
| FR-POSE-004 | Frames below configurable landmark/presence confidence shall not be used for counting or form scoring. | Must | US-EXERCISE-003, US-EXERCISE-008 | Test |
| FR-POSE-005 | When required landmarks are lost for a configurable interval, the system shall pause evaluation and display repositioning guidance. | Must | US-EXERCISE-008 | Test |

## 6. Rep Counting

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-REP-001 | A rep shall be counted only after the exercise completes its valid ordered state transition. | Must | US-EXERCISE-004 | Unit/scenario test |
| FR-REP-002 | Holding one state or replaying equivalent frames shall not generate duplicate reps. | Must | US-EXERCISE-004 | Test |
| FR-REP-003 | Partial, reversed, out-of-order, and low-confidence transitions shall not increment valid reps. | Must | US-EXERCISE-004 | Test |
| FR-REP-004 | Each counted attempt shall create at most one timestamped rep event linked to the workout and rule version. | Must | US-EXERCISE-004, US-EXERCISE-007 | Data test |

## 7. Form Feedback

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-FORM-001 | The system shall evaluate configured exercise-specific landmark and angle rules only on eligible frames/states. | Must | US-EXERCISE-005 | Unit test |
| FR-FORM-002 | Feedback shall identify an actionable observable adjustment and shall not diagnose injury or medical conditions. | Must | US-EXERCISE-005 | Content inspection |
| FR-FORM-003 | The UI shall limit simultaneous cues according to a configurable priority so feedback remains readable. | Should | US-EXERCISE-005 | Test |
| FR-FORM-004 | Session results shall retain structured issue codes/counts and the rule version, not raw frames. | Must | US-EXERCISE-007 | Data inspection |

## 8. Workout-Session Management

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-WORKOUT-001 | A workout shall begin after instructions and a visible countdown. | Must | US-EXERCISE-002 | Demonstration |
| FR-WORKOUT-002 | Pause shall stop active duration, rep transitions, and form evaluation; resume shall continue the same session. | Must | US-EXERCISE-006 | Test |
| FR-WORKOUT-003 | Finish shall finalize exactly one result containing exercise, active duration, total/valid/invalid reps, form summary, and timestamps. | Must | US-EXERCISE-006, US-EXERCISE-007 | Test |

## 9. Offline Storage and Synchronization

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-SYNC-001 | Completed workouts and runs shall be committed locally before cloud synchronization is attempted. | Must | US-HISTORY-001 | Failure-injection test |
| FR-SYNC-002 | The system shall queue unsynchronized records and retry after connectivity returns or on user request. | Must | US-SYNC-001, US-SYNC-002 | Test |
| FR-SYNC-003 | Synchronization retries shall use stable client session IDs/idempotency semantics and shall not create duplicate sessions. | Must | US-SYNC-001 | Integration test |
| FR-SYNC-004 | Sync status shall distinguish pending, synchronized, and failed-with-retry states. | Must | US-SYNC-002, US-HISTORY-002 | Test |
| FR-SYNC-005 | A conflict policy shall preserve the immutable completed-session payload and use an explicit server response for profile-field conflicts. | Must | US-SYNC-001 | Integration test, Inspection |

## 10. GPS Running

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-RUN-001 | During an active run, the system shall display active duration, distance, current/average speed, and current/average pace. | Must | US-RUN-001 | Test |
| FR-RUN-002 | The system shall store an ordered GPS route with timestamp and accuracy for accepted or explicitly flagged points. | Must | US-RUN-001 | Data test |
| FR-RUN-003 | GPS points exceeding a configurable unacceptable-accuracy limit shall be rejected or flagged and excluded from trusted distance unless the documented algorithm accepts them. | Must | US-RUN-004 | Algorithm test |
| FR-RUN-004 | Distance shall be accumulated from validated consecutive points and shall suppress implausible jumps using configurable rules. | Must | US-RUN-001, US-RUN-004 | Algorithm test |
| FR-RUN-005 | Running shall support pause, resume, and finish; paused intervals and points shall not contribute to active metrics. | Must | US-RUN-003 | Test |
| FR-RUN-006 | On supported Android configurations, the system shall continue an explicitly active run in the background using the required visible foreground-service indication. | Must | US-RUN-002 | Device test |
| FR-RUN-007 | When GPS becomes unavailable, the system shall retain the session, display degraded status, and resume collection without inventing route points. | Must | US-RUN-004 | Test |

## 11. History

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-HISTORY-001 | The system shall list the authenticated user's workout and running sessions in reverse chronological order. | Must | US-HISTORY-002 | Test |
| FR-HISTORY-002 | Session details shall display the stored summary and sync state; run details shall display an available route. | Must | US-HISTORY-002 | Test |

## 12. Analytics

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-ANALYTICS-001 | The system shall calculate date-bounded strength totals and running totals/trends from the user's stored completed sessions. | Must | US-ANALYTICS-001 | Analysis, Test |
| FR-ANALYTICS-002 | Rule-based insights shall state the measured basis/time period and shall not present medical, injury, or calorie-restriction advice. | Should | US-ANALYTICS-002 | Content inspection |
| FR-ANALYTICS-003 | Analytics shall exclude deleted, foreign-user, and incomplete sessions unless explicitly labeled. | Must | US-ANALYTICS-001 | Test |

## 13. Settings

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-SETTINGS-001 | The user shall be able to select metric or imperial display units. | Must | US-SETTINGS-001 | Test |
| FR-SETTINGS-002 | Unit changes shall convert displayed values from canonical stored units without rewriting historical measurements. | Must | US-SETTINGS-001 | Test |
| FR-SETTINGS-003 | Core interactive controls shall expose accessible labels and support platform text scaling. | Should | US-ACCESS-001 | Accessibility test |

## 14. Privacy and Data Deletion

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-PRIVACY-001 | API and local queries shall enforce current-user ownership of profiles and sessions. | Must | US-PRIVACY-003, US-HISTORY-002 | Security test |
| FR-PRIVACY-002 | After explicit confirmation and recent authentication when required, account deletion shall remove local user records and request deletion of cloud profile/activity records. | Must | US-PRIVACY-003 | End-to-end test |
| FR-PRIVACY-003 | The deletion flow shall report pending/failed server deletion without falsely claiming completion and shall permit retry. | Must | US-PRIVACY-003 | Failure-injection test |

## 15. Error Handling

| ID | Requirement | Priority | Related story | Verification |
|---|---|---|---|---|
| FR-ERROR-001 | Recoverable camera, pose, location, storage, authentication, and network errors shall show a user-safe message and a relevant retry or exit action. | Must | US-EXERCISE-008, US-RUN-004, US-SYNC-002 | Scenario test |
| FR-ERROR-002 | An error shall not erase a locally committed session or silently count unverified movement. | Must | US-HISTORY-001, US-SYNC-002 | Failure-injection test |
| FR-ERROR-003 | Diagnostic records shall use non-sensitive codes and shall exclude tokens, raw frames, and precise route coordinates by default. | Must | US-PRIVACY-001, US-PRIVACY-002 | Inspection |

