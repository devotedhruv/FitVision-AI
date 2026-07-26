import 'dart:ui';

class PoseLandmark {
  const PoseLandmark({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
    required this.presence,
  });

  factory PoseLandmark.fromMap(Map<Object?, Object?> map) => PoseLandmark(
    index: (map['index'] as num).toInt(),
    x: (map['x'] as num).toDouble(),
    y: (map['y'] as num).toDouble(),
    z: (map['z'] as num).toDouble(),
    visibility: (map['visibility'] as num?)?.toDouble() ?? 0,
    presence: (map['presence'] as num?)?.toDouble() ?? 0,
  );

  final int index;
  final double x;
  final double y;
  final double z;
  final double visibility;
  final double presence;

  bool isVisible(double threshold) =>
      visibility >= threshold && presence >= threshold;

  Offset toPreviewOffset(
    Size size, {
    required bool mirrored,
    int rotation = 0,
  }) {
    var normalizedX = x;
    var normalizedY = y;
    switch (rotation % 360) {
      case 90:
        (normalizedX, normalizedY) = (1 - normalizedY, normalizedX);
      case 180:
        normalizedX = 1 - normalizedX;
        normalizedY = 1 - normalizedY;
      case 270:
        (normalizedX, normalizedY) = (normalizedY, 1 - normalizedX);
    }
    if (mirrored) normalizedX = 1 - normalizedX;
    return Offset(normalizedX * size.width, normalizedY * size.height);
  }
}
