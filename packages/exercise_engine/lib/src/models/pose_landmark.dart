enum LandmarkType {
  nose(0),
  leftShoulder(11),
  rightShoulder(12),
  leftElbow(13),
  rightElbow(14),
  leftWrist(15),
  rightWrist(16),
  leftHip(23),
  rightHip(24),
  leftKnee(25),
  rightKnee(26),
  leftAnkle(27),
  rightAnkle(28);

  const LandmarkType(this.landmarkIndex);
  final int landmarkIndex;

  static LandmarkType? fromIndex(int index) {
    for (final value in values) {
      if (value.landmarkIndex == index) return value;
    }
    return null;
  }
}

class PoseLandmark {
  const PoseLandmark({
    required this.index,
    required this.x,
    required this.y,
    this.z,
    required this.visibility,
    this.presence,
  });

  final int index;
  final double x;
  final double y;
  final double? z;
  final double visibility;
  final double? presence;
  LandmarkType? get type => LandmarkType.fromIndex(index);
  double get confidence => presence == null
      ? visibility
      : (visibility < presence! ? visibility : presence!);

  PoseLandmark copyWith({double? x, double? y, double? z}) => PoseLandmark(
    index: index,
    x: x ?? this.x,
    y: y ?? this.y,
    z: z ?? this.z,
    visibility: visibility,
    presence: presence,
  );
}
