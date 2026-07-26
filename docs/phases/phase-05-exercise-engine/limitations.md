# Limitations

- Thresholds have synthetic-test validation only; physical-device calibration
  with diverse participants and camera placements remains required.
- Angles use normalized 2D image coordinates because monocular depth is not
  reliable enough for the initial rules.
- Squat knee alignment and torso lean are not scored because a single camera
  view does not make them reliable across front and side placements.
- Push-up alignment is evaluated only when shoulder, hip and ankle are visible.
- Curl upper-arm displacement depends on a visible shoulder-width scale.
- Only one detected person is supported. Occlusion and loose clothing can
  reduce accuracy.
- Audio uses the existing short system cue, not spoken localization.
- Shoulder press, lunges and other catalogue items retain camera tracking but
  do not receive Phase 5 rep analysis.

The engine provides neutral movement cues. It does not diagnose conditions,
predict injury, prescribe rehabilitation or replace qualified guidance.
