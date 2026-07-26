# Pose Result Contract

Every native event contains:

| Field | Type | Meaning |
|---|---|---|
| `timestamp` | integer | monotonic inference timestamp in milliseconds |
| `imageWidth`, `imageHeight` | integer | rotated inference image dimensions |
| `rotation` | integer | residual rotation; currently zero after native rotation |
| `lensDirection` | string | `front` or `back` |
| `inferenceLatencyMs` | number | native submit-to-result latency |
| `poseDetected` | boolean | at least one pose result exists |
| `status` | string | stable tracking status |
| `landmarks` | list | up to 33 normalized landmarks |
| `worldLandmarks` | list | MediaPipe world landmarks |
| `processedFps` | number | processed-result rate since initialization |
| `droppedFrames` | integer | frames rejected by the busy guard |
| `message` | string | safe user-facing camera-placement guidance |

Each landmark contains `index`, `x`, `y`, `z`, `visibility` and `presence`.
Stable statuses are `initializing`, `ready`, `detecting`, `poseDetected`,
`noPose`, `partialPose`, `poorVisibility`, `paused`, `permissionDenied`,
`modelError`, `cameraError` and `disposed`.

Native rotation is applied before inference. Flutter uses a `BoxFit.cover`
equivalent scale/offset and mirrors normalized X only for the front camera.
Connections are omitted when either endpoint has visibility or presence below
0.5.

`ExerciseAnalysisState` is the Phase 5 boundary. In Phase 4 its stage remains
`READY`, all rep values remain zero, and form text describes camera readiness
only.
