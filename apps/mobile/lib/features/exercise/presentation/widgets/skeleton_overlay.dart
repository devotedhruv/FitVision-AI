import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pose_landmarker/pose_landmarker.dart';

@visibleForTesting
bool poseDebugOverlayEnabled({
  required bool requested,
  required bool isDebugBuild,
}) => requested && isDebugBuild;

class SkeletonOverlay extends StatelessWidget {
  const SkeletonOverlay({
    required this.result,
    this.showDebug = false,
    super.key,
  });

  final PoseResult? result;
  final bool showDebug;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: CustomPaint(
      key: const Key('skeleton-overlay'),
      painter: SkeletonPainter(
        result,
        showDebug: poseDebugOverlayEnabled(
          requested: showDebug,
          isDebugBuild: kDebugMode,
        ),
      ),
      child: const SizedBox.expand(),
    ),
  );
}

class SkeletonPainter extends CustomPainter {
  const SkeletonPainter(this.result, {this.showDebug = false});
  final PoseResult? result;
  final bool showDebug;

  static const connections = <(int, int)>[
    (0, 1),
    (1, 2),
    (2, 3),
    (3, 7),
    (0, 4),
    (4, 5),
    (5, 6),
    (6, 8),
    (9, 10),
    (11, 12),
    (11, 13),
    (13, 15),
    (15, 17),
    (15, 19),
    (15, 21),
    (17, 19),
    (12, 14),
    (14, 16),
    (16, 18),
    (16, 20),
    (16, 22),
    (18, 20),
    (11, 23),
    (12, 24),
    (23, 24),
    (23, 25),
    (25, 27),
    (27, 29),
    (29, 31),
    (27, 31),
    (24, 26),
    (26, 28),
    (28, 30),
    (30, 32),
    (28, 32),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final frame = result;
    if (frame == null ||
        !frame.poseDetected ||
        frame.landmarks.length != 33 ||
        frame.imageWidth <= 0 ||
        frame.imageHeight <= 0) {
      return;
    }
    const threshold = 0.5;
    final scale = _coverScale(frame, size);
    Offset point(PoseLandmark landmark) {
      final x = frame.mirrored ? 1 - landmark.x : landmark.x;
      return Offset(
        x * frame.imageWidth * scale +
            (size.width - frame.imageWidth * scale) / 2,
        landmark.y * frame.imageHeight * scale +
            (size.height - frame.imageHeight * scale) / 2,
      );
    }

    final linePaint = Paint()
      ..color = const Color(0xFF42F5C5)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final pointPaint = Paint()..color = const Color(0xFFFFD166);
    for (final (start, end) in connections) {
      final a = frame.landmarks[start];
      final b = frame.landmarks[end];
      if (a.isVisible(threshold) && b.isVisible(threshold)) {
        canvas.drawLine(point(a), point(b), linePaint);
      }
    }
    final debugPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final landmark in frame.landmarks) {
      if (!landmark.isVisible(threshold)) continue;
      final offset = point(landmark);
      canvas.drawCircle(offset, 4, pointPaint);
      if (showDebug) {
        debugPainter.text = TextSpan(
          text: '${landmark.index}',
          style: const TextStyle(color: Colors.white, fontSize: 9),
        );
        debugPainter.layout();
        debugPainter.paint(canvas, offset + const Offset(4, -10));
      }
    }
    if (showDebug) {
      debugPainter.text = TextSpan(
        text:
            '${frame.processedFps.toStringAsFixed(1)} FPS • '
            '${frame.inferenceLatencyMs.toStringAsFixed(0)} ms',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          backgroundColor: Colors.black54,
        ),
      );
      debugPainter.layout();
      debugPainter.paint(canvas, const Offset(8, 8));
    }
  }

  static double _coverScale(PoseResult frame, Size size) => [
    size.width / frame.imageWidth,
    size.height / frame.imageHeight,
  ].reduce((a, b) => a > b ? a : b);

  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) =>
      oldDelegate.result?.timestampMs != result?.timestampMs ||
      oldDelegate.showDebug != showDebug;
}
