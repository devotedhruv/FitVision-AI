# FitVision AI

FitVision AI is an Android-first mobile-system project for future on-device exercise pose monitoring and GPS running tracking. The current repository contains the complete Phase 0 requirements and an operational Phase 1 FastAPI foundation.

> **Current status: Phase 1 partially complete. The FastAPI foundation is operational; Flutter/Android foundation work is blocked because Flutter, Dart, ADB, and Android tooling are unavailable in the execution environment.**

The intended completion statement—“Phase 1 completed — Flutter and FastAPI foundations are operational”—is **not yet true**. Authentication, database, AI pose estimation, exercise tracking, GPS tracking, and final UI are not implemented.

## Problem Being Solved

Manual rep counting is distracting and unreliable, unsupervised exercise offers little immediate form feedback, wearables generally do not evaluate camera-observed form, and strength/running records are frequently fragmented. FitVision AI plans to address these gaps without uploading raw workout video by default and without presenting automated feedback as medical advice.

## Planned Features and MVP

- On-device pose landmarks, full-transition rep counting, and rule-based form feedback.
- **MVP exercises:** squats, biceps curls, and push-ups.
- **Extended scope:** lunges and planks after MVP validation.
- Running duration, route, distance, current/average speed, and current/average pace.
- Pause/resume/finish controls for workouts and runs.
- Local-first persistence, idempotent synchronization, combined history, and rule-based analytics.
- Authentication, profile/unit settings, permission recovery, user-data isolation, and deletion.

## Planned Technology Stack

| Layer | Planned technology |
|---|---|
| Mobile | Flutter and Dart, Android-first |
| Pose integration | MediaPipe Pose Landmarker via Kotlin and Pigeon or typed platform channels |
| Exercise logic | Versioned, rule-based state machines |
| Local data | SQLite with Drift |
| API | FastAPI REST service |
| Identity/cloud data | Supabase Auth and PostgreSQL through Supabase |
| Running | Android location services and a maps provider (selection pending) |
| Delivery | Docker and GitHub Actions in later phases |

## High-Level Architecture

Camera frames are processed on the device. Flutter use cases coordinate the native MediaPipe bridge, exercise engine, GPS service, local database, and offline queue. Only structured session/profile/route data is synchronized to FastAPI, which applies business and ownership rules and accesses PostgreSQL; Supabase Auth supplies identity. See the architecture diagram below for boundaries.

## Phase Roadmap

1. **Phase 0 — Planning and requirement analysis (complete):** scope, traceable requirements, acceptance baseline, risks, and diagrams.
2. **Phase 1 — Project foundation (blocked / partial):** FastAPI, environment configuration, tests, and health contract are complete; Flutter generation and mobile validation remain blocked.
3. **Phase 2 — UI/UX, design system, application navigation and mock-data screens:** begins only after Phase 1 mobile acceptance checks pass.
4. **Later implementation phases:** camera/native pose integration, exercise rules, running, authentication/data, history/analytics, validation, and delivery remain subject to the Phase 0 requirements and future phase plans.

Roadmap phases after Phase 0 are planning guidance and may change through controlled review.

## Current Repository Structure

```text
fitvision-ai/
├── docs/
│   ├── diagrams/
│   └── phases/
│       ├── phase-00-planning/
│       └── phase-01-foundation/
├── services/
│   └── api/
│       ├── app/
│       ├── tests/
│       ├── pyproject.toml
│       └── uv.lock
├── .env.example
├── .gitignore
└── README.md
```

`apps/mobile/` is intentionally absent: the required `flutter create` command could not run, and generated Android files have not been fabricated.

## Prerequisites

- Python 3.12 or newer and [`uv`](https://docs.astral.sh/uv/) for the backend.
- Stable Flutter SDK, Dart SDK, Android SDK/toolchain, and ADB for the mobile project. These mobile prerequisites are currently missing from this environment.

## Backend Setup and Commands

From the repository root:

```bash
cd services/api
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv sync --all-groups
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Run validation from `services/api/`:

```bash
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run ruff check .
UV_CACHE_DIR=/tmp/fitvision-uv-cache uv run pytest
```

The health endpoint is `http://127.0.0.1:8000/api/v1/health`; interactive API documentation is at `http://127.0.0.1:8000/docs`.

## Environment Configuration

Backend configuration is loaded from environment variables or an ignored `services/api/.env`; [.env.example](.env.example) documents safe names and empty future placeholders. Never commit real credentials.

The planned Android emulator URL is `http://10.0.2.2:8000`. For a physical device, use `adb reverse tcp:8000 tcp:8000` and then `http://127.0.0.1:8000`. Local cleartext HTTP will be allowed only in the generated Android debug manifest; production will require HTTPS.

## Mobile Setup Status

No mobile setup/run/test command is currently valid because `apps/mobile/pubspec.yaml` does not exist. Once Flutter is installed, resume with the safe initialization command documented in the [Phase 1 setup guide](docs/phases/phase-01-foundation/setup-guide.md). Dependency resolution, architecture implementation, analysis, tests, and debug APK validation must then be completed before Phase 1 can close.

## Phase 0 Documentation

- [Problem statement](docs/phases/phase-00-planning/problem-statement.md)
- [Scope](docs/phases/phase-00-planning/scope.md)
- [User stories](docs/phases/phase-00-planning/user-stories.md)
- [Functional requirements](docs/phases/phase-00-planning/functional-requirements.md)
- [Non-functional requirements](docs/phases/phase-00-planning/non-functional-requirements.md)
- [Supported exercises](docs/phases/phase-00-planning/supported-exercises.md)
- [Acceptance criteria and Definition of Done](docs/phases/phase-00-planning/acceptance-criteria.md)
- [Risk register](docs/phases/phase-00-planning/risks.md)
- [Editable diagram sources](docs/diagrams/source/)

## Phase 1 Documentation

- [Implementation summary](docs/phases/phase-01-foundation/implementation-summary.md)
- [Setup guide](docs/phases/phase-01-foundation/setup-guide.md)
- [Architecture decisions](docs/phases/phase-01-foundation/architecture-decisions.md)
- [Validation report](docs/phases/phase-01-foundation/validation-report.md)

## Diagrams

### System architecture

![FitVision AI system architecture](docs/diagrams/system-architecture.png)

### User flow

![FitVision AI user flow](docs/diagrams/user-flow.png)

### Conceptual database ERD

![FitVision AI conceptual database ERD](docs/diagrams/database-erd.png)

The ERD is conceptual only; Phase 0 includes no migrations or production database schema.

## Team

This project is intended for a four-person development team. The proposal presentation was not available in the repository during Phase 0, so names and final responsibility assignments remain **to be confirmed from the proposal/project owner** rather than invented. Suggested responsibility areas are mobile/UX, pose/native integration, backend/data, and QA/DevOps, with cross-review to reduce single-person dependency.

## Current Limitations

- The backend is a foundation service with only `/`, `/docs`, and `/api/v1/health`; no business API exists.
- The Flutter/Android application does not yet exist because its SDK/toolchain is unavailable.
- Thresholds, model performance, supported Android versions/devices, GPS filters, maps provider, and sync conflict details require Phase 1 decisions and empirical validation.
- Only one user in supported views/conditions is planned for pose monitoring.
- Automated cues may be wrong when landmarks are uncertain and are not a substitute for a qualified professional.

## Safety and Privacy

FitVision AI is an automated fitness guidance and record-keeping concept, **not a medical diagnosis, injury diagnosis, rehabilitation, or emergency system**. Users should stop exercise when they experience pain or unsafe symptoms and seek qualified advice where appropriate. Pose inference is planned on-device; raw camera frames are not uploaded by default. Structured workout data and precise running routes are sensitive and must use explicit permissions, minimized collection, HTTPS, user-scoped authorization, and reliable deletion controls.

## Next Phase

First, unblock and finish Phase 1 by installing a stable Flutter/Android toolchain outside the repository, genuinely generating `apps/mobile/`, implementing the documented mobile foundation, and passing analysis, tests, and a debug APK build.

After that gate, the next phase is **Phase 2 — UI/UX, design system, application navigation and mock-data screens**. Its first task should define design tokens and accessible navigation shells using mock-only domain data, without introducing authentication, sensors, persistence, or backend business features.
