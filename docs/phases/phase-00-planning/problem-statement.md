# Problem Statement

## Background

FitVision AI is a proposed Android-first fitness application that joins camera-assisted strength-exercise monitoring with GPS running records. It is intended for people who train without continuous supervision and need immediate, understandable guidance plus a coherent record of activity.

## Existing Problem

Manual rep counting is distracting and unreliable, particularly when a user is also trying to maintain technique. Unsupervised users often receive no immediate form feedback. Wearables generally do not provide camera-based exercise-form evaluation, and fitness and running records are often fragmented across different applications or notebooks. This makes it difficult to review progress consistently.

## Limitations of Current Methods

- Manual logs depend on memory and interrupt the workout.
- Simple timers and motion sensors do not explain visible joint relationships.
- Generic video instruction cannot react to the current repetition.
- Human coaching is valuable but may not be continuously available or affordable.
- Cloud-video analysis can add latency and privacy risk.
- Separate strength and running tools prevent a unified activity history.

## Target Users

The primary users are adult beginners and recreational exercisers with a supported Android phone who perform basic strength exercises or outdoor runs. Users must be physically able to exercise independently and remain responsible for stopping if they experience pain, dizziness, or unsafe conditions.

## Proposed Solution

The application will guide exercise selection and camera placement, estimate body landmarks from live camera frames, run exercise-specific state machines, count valid repetitions, and display rule-based form cues. It will also record outdoor runs using GPS, save both activity types locally first, synchronize structured summaries when connectivity permits, and present history and rule-based progress insights.

## Why On-Device Pose Estimation

On-device inference can provide low-latency feedback, remain useful without a network connection, reduce network consumption, and keep raw camera frames on the phone by default. MediaPipe Pose Landmarker is the planned detector; its suitability and performance remain subject to validation on target devices.

## Why Combine Strength and Running

Many recreational users mix strength training with aerobic running. One history, profile, unit preference, and analytics experience reduces fragmentation and allows progress to be reviewed across both activity types without implying medical or physiological diagnosis.

## Expected Project Value

- Less attention spent on counting repetitions.
- Immediate, repeatable, rule-based technique prompts.
- Privacy-conscious camera processing and offline-first recording.
- A consolidated, inspectable history for strength workouts and runs.
- A modular academic platform for evaluating mobile pose and location techniques.

## Assumptions

- The proposal presentation was unavailable during Phase 0; this document uses the supplied project brief as the source.
- Initial users are adults using supported Android devices with a camera, GPS, and sufficient storage.
- The user selects the exercise; universal automatic exercise recognition is not required.
- A single person is visible and follows the stated camera view and environment guidance.
- Internet access is required for authentication and synchronization, but not for an already-authorized local workout.
- Thresholds and feedback rules are configurable engineering values requiring calibration and expert review.
- Team-member names and institutional details remain to be supplied from the proposal or by the project owner.

## Constraints

- Phase 0 produces planning artifacts only; no mobile, API, or database implementation is included.
- The first release is Android-first and limited to the exercises in [Supported Exercises](supported-exercises.md).
- Pose quality depends on device capability, lighting, clothing, camera placement, and landmark visibility.
- GPS accuracy and background execution depend on hardware, environment, OS policy, and user permissions.
- The system provides automated guidance and is **not a medical diagnosis, injury-diagnosis, rehabilitation, or emergency-response system**.
- Raw workout video will not be uploaded to the backend by default.

