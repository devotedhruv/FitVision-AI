# Supported Exercises and Conceptual Rules

These rules guide later engineering; they are not implementation or medical standards. Joint-angle thresholds, confidence limits, dwell times, symmetry tolerances, and hold durations are configurable engineering values requiring device calibration, diverse test data, and qualified exercise-professional review. Feedback describes observable pose relationships and does not diagnose safety or injury.

## Summary

| Exercise | Stage | Recommended view | Conceptual states |
|---|---|---|---|
| Squat | MVP | Side preferred; front optional for symmetry rules | `READY → DESCENDING → BOTTOM → ASCENDING → COMPLETE` |
| Biceps curl | MVP | Side, working arm fully visible | `EXTENDED → CURLING → CONTRACTED → LOWERING → COMPLETE` |
| Push-up | MVP | Side, entire body visible | `TOP → LOWERING → BOTTOM → RISING → COMPLETE` |
| Lunge | Extended | Side, both legs and torso visible | `STANDING → DESCENDING → BOTTOM → RISING → COMPLETE` |
| Plank | Extended | Side, entire body visible | `NOT_READY → ALIGNED → HOLDING → COMPLETE` |

## Squat

- **Main landmarks:** shoulders, hips, knees, ankles; optionally heels/feet.
- **Relationships:** hip–knee–ankle knee angle; shoulder–hip–knee hip/trunk relationship; knee/foot alignment where the selected view supports it.
- **Rep states:** `READY → DESCENDING → BOTTOM → ASCENDING → COMPLETE`.
- **Completion:** begin in stable READY, pass downward through DESCENDING to a calibrated BOTTOM, then return through ASCENDING to the upright completion boundary once.
- **Initial form checks:** sufficient depth relative to calibrated knee/hip geometry; controlled trunk inclination; knee tracking observable from the supported view; full return without prolonged loss of landmarks.
- **Instructions:** place the phone securely at roughly hip height in the instructed side view; keep full body and feet visible; use even lighting; clear the area; move at a controlled pace.
- **Known limitations:** loose clothing, atypical proportions/mobility, camera perspective, heel occlusion, and front/side ambiguity affect measurements.
- **Unsupported conditions:** seated/assisted or weighted variations with major occlusion, multiple people, moving camera, cropped knees/ankles, extreme low light.

## Biceps Curl

- **Main landmarks:** shoulder, elbow, wrist, hip on the working side.
- **Relationships:** shoulder–elbow–wrist elbow angle; elbow displacement relative to shoulder/torso; torso motion.
- **Rep states:** `EXTENDED → CURLING → CONTRACTED → LOWERING → COMPLETE`.
- **Completion:** begin at calibrated extension, flex through CURLING to CONTRACTED, then lower under observation to the extension completion boundary once.
- **Initial form checks:** adequate extension and contraction range; elbow remains near its reference position; limited torso swing; wrist/arm landmarks remain visible.
- **Instructions:** use a stable side view with the complete working arm visible; stand clear of the frame edges; use a manageable load and controlled motion.
- **Known limitations:** dumbbells/sleeves may occlude wrist or elbow; bilateral curls can overlap; camera depth makes elbow drift hard to estimate.
- **Unsupported conditions:** cable/machine or seated variants not calibrated, overlapping arms, cropped wrist/shoulder, rapid ballistic movement.

## Push-Up

- **Main landmarks:** shoulder, elbow, wrist, hip, knee, ankle on the visible side.
- **Relationships:** shoulder–elbow–wrist elbow angle; shoulder–hip–ankle body-line relationship; shoulder position relative to wrist.
- **Rep states:** `TOP → LOWERING → BOTTOM → RISING → COMPLETE`.
- **Completion:** establish TOP, lower through LOWERING to the calibrated BOTTOM boundary, then rise to the top extension completion boundary once.
- **Initial form checks:** observable depth; continuous shoulder–hip–ankle alignment within tolerance; hand/shoulder relationship; complete return.
- **Instructions:** position the phone securely side-on with head through feet visible; keep the floor area clear; begin only after the app confirms a usable pose.
- **Known limitations:** floor-level occlusion, wide/diamond hand positions, lens perspective, hair/clothing, and knee push-ups change geometry.
- **Unsupported conditions:** knee/incline/decline/one-arm variants until separately calibrated, cropped ankles or arms, camera at head/foot axis, multiple people.

## Lunge

- **Main landmarks:** shoulders, hips, both knees, both ankles/feet.
- **Relationships:** front and rear knee angles; hip height; torso inclination; stance and knee/foot alignment where visible.
- **Rep states:** `STANDING → DESCENDING → BOTTOM → RISING → COMPLETE`.
- **Completion:** establish the intended stance/standing state, descend to a calibrated bottom, then rise to the completion boundary with the tracked leg identity unchanged.
- **Initial form checks:** controlled torso, sufficient depth, stable front-knee/foot relationship, and consistent tracked-leg identity.
- **Instructions:** use the stated side view, keep both legs visible throughout, allow enough floor space, and perform one stationary lunge pattern at a time.
- **Known limitations:** crossing limbs and leg-identity swaps; walking/reverse/side lunges have different geometry.
- **Unsupported conditions:** walking or lateral variants until calibrated, severe limb overlap, cropped rear foot, moving camera.

## Plank

- **Main landmarks:** shoulder, elbow/wrist as applicable, hip, knee, ankle.
- **Relationships:** shoulder–hip–ankle alignment; hip displacement; support-joint placement; sustained confidence.
- **States:** `NOT_READY → ALIGNED → HOLDING → COMPLETE` (time-based, not repetition-based).
- **Completion:** maintain ALIGNED continuously for the configured target hold time; invalid/lost-pose intervals beyond tolerance pause or reset the hold according to the calibrated rule.
- **Initial form checks:** hips within alignment tolerance, stable support position, required landmarks visible, and no prolonged alignment break.
- **Instructions:** choose forearm or high-plank mode when supported; place the phone side-on with full body visible; hold only while comfortable and stop for pain.
- **Known limitations:** small perspective errors can materially change apparent alignment; floor occlusion and body proportions affect the rule.
- **Unsupported conditions:** side/dynamic/weighted planks, cropped lower body, unstable camera, mode not explicitly selected.

## Common State-Machine Safeguards

- Use hysteresis and minimum dwell/motion evidence to avoid boundary oscillation.
- Freeze or reset transitions after configurable low-confidence/lost-landmark periods.
- Never infer skipped states as a complete rep.
- Emit at most one completion event until the machine re-arms at its valid starting boundary.
- Store the exercise rule version with each session so later rule changes do not rewrite history.

