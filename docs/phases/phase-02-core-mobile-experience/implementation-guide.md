# Phase 2 — Core Mobile Experience

## Scope

Phase 2 turns the Phase 1 Flutter foundation into a navigable, responsive
fitness prototype. It adds a reusable design system, five-tab application
shell, dashboard, exercise catalogue and detail flow, simulated live session,
and meaningful running, history, analytics, and profile previews.

No screen requests camera or location permission. No mock screen claims to
perform real tracking, posture analysis, medical diagnosis, or GPS recording.

## Screens and Navigation

```text
/onboarding
/dashboard                    Home tab
/exercises                    Exercises tab
  └─ /exercises/:exerciseId
       └─ /exercises/:exerciseId/live
/running                      Running tab
/history                      History tab
/profile                      Profile tab
/analytics                    Dashboard/Profile shortcut
unknown route                 Recoverable not-found page
```

`StatefulShellRoute.indexedStack` preserves the five main tab navigators.
Exercise IDs are resolved safely; an unknown ID renders recovery UI rather
than throwing. Live sessions and analytics use the root navigator, so Android
back returns to the originating screen.

## Exercise Model

`Exercise` is immutable and contains an ID, display name, typed category and
difficulty, description, instructions, target muscles, estimated duration,
equipment, safe illustration identifier, typed tracking mode, and
beginner-friendly flag. Seven local exercises cover strength, mobility, core,
and cardio. Tracking modes explicitly distinguish simulated pose UI from
manual demo sessions.

## Mock Data

Dashboard and exercise data live in repository classes rather than widgets.
Repositories expose deterministic `data`, `empty`, and `error` modes, and use a
short delay to exercise loading UI. Riverpod providers make each repository
replaceable in tests and create a clean future API boundary.

All analytics, form scores, calories, history, feedback, repetition results,
and running values are visibly labelled as demo or estimate data.

## Live Session State

```text
initial → ready → active ⇄ paused → completed
                    └─────────────→ error
```

The Riverpod `Notifier` owns repetitions, timer, feedback, form status, and
transitions. Invalid transitions are ignored safely. Demo controls simulate a
correct repetition or a form cue; they never access a camera or pose model.

## Run and Test

From `apps/mobile/`:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

The app uses the system light/dark preference. The Phase 2 interface works
without internet, platform channels, backend, camera, or GPS.

## Current Limitations

- Camera preview, pose tracking, repetition detection, and form feedback are
  simulations only.
- Running does not read location, draw maps, or calculate distance and pace.
- Data is not persisted and resets between app launches.
- No authentication, cloud sync, notifications, or health-platform access.
- Exercise guidance is general fitness information, not medical advice.
- App version is a Phase 2 placeholder derived from the current package version.

## Recommended Phase 3

Phase 3 should validate one end-to-end on-device exercise pipeline before
expanding breadth: explicit camera consent, lifecycle-safe camera preview,
on-device pose landmarks, confidence/visibility handling, a tested
exercise-specific repetition state machine, uncertainty-aware feedback, and
local session persistence. It should include device performance, privacy,
accessibility, and failure testing. GPS, backend accounts, and cloud sync
should remain separate workstreams with their own permission and data-design
reviews.
