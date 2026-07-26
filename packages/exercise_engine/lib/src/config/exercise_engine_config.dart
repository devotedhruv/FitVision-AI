class SmoothingConfig {
  const SmoothingConfig({
    this.alpha = .35,
    this.resetGap = const Duration(milliseconds: 750),
  });
  final double alpha;
  final Duration resetGap;
}

class VisibilityConfig {
  const VisibilityConfig({this.threshold = .60, this.sideSwitchMargin = .15});
  final double threshold;
  final double sideSwitchMargin;
}

class FeedbackConfig {
  const FeedbackConfig({this.cooldown = const Duration(milliseconds: 1500)});
  final Duration cooldown;
}

class RepTimingConfig {
  const RepTimingConfig({
    this.minimumStableFrames = 3,
    this.minimumDuration = const Duration(milliseconds: 500),
    this.maximumDuration = const Duration(seconds: 10),
  });
  final int minimumStableFrames;
  final Duration minimumDuration;
  final Duration maximumDuration;
}

class SquatConfig {
  const SquatConfig({
    this.standingAngle = 160,
    this.descendingAngle = 155,
    this.bottomAngle = 100,
    this.ascendingAngle = 105,
  });
  final double standingAngle, descendingAngle, bottomAngle, ascendingAngle;
}

class CurlConfig {
  const CurlConfig({
    this.extendedAngle = 155,
    this.flexingAngle = 145,
    this.contractedAngle = 55,
    this.extendingAngle = 65,
    this.upperArmDisplacementTolerance = .25,
  });
  final double extendedAngle, flexingAngle, contractedAngle, extendingAngle;
  final double upperArmDisplacementTolerance;
}

class PushupConfig {
  const PushupConfig({
    this.topAngle = 155,
    this.descendingAngle = 145,
    this.bottomAngle = 90,
    this.ascendingAngle = 100,
    this.alignmentAngle = 160,
  });
  final double topAngle,
      descendingAngle,
      bottomAngle,
      ascendingAngle,
      alignmentAngle;
}

class ExerciseEngineConfig {
  const ExerciseEngineConfig({
    this.smoothing = const SmoothingConfig(),
    this.visibility = const VisibilityConfig(),
    this.feedback = const FeedbackConfig(),
    this.repTiming = const RepTimingConfig(),
    this.squat = const SquatConfig(),
    this.curl = const CurlConfig(),
    this.pushup = const PushupConfig(),
  });
  final SmoothingConfig smoothing;
  final VisibilityConfig visibility;
  final FeedbackConfig feedback;
  final RepTimingConfig repTiming;
  final SquatConfig squat;
  final CurlConfig curl;
  final PushupConfig pushup;
}
