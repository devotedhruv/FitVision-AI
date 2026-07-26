import 'dart:ui' as ui;

import 'package:fitvision_ai/features/exercise/presentation/widgets/skeleton_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pose_landmarker/pose_landmarker.dart';

void main() {
  testWidgets('skeleton overlay renders fake landmarks without overflow', (
    tester,
  ) async {
    final result = PoseResult(
      timestampMs: 1,
      imageWidth: 480,
      imageHeight: 640,
      rotation: 0,
      lensDirection: CameraLensDirection.front,
      inferenceLatencyMs: 40,
      poseDetected: true,
      status: PoseStatus.poseDetected,
      landmarks: List.generate(
        33,
        (index) => PoseLandmark(
          index: index,
          x: 0.2 + (index % 5) * 0.1,
          y: 0.1 + (index ~/ 5) * 0.1,
          z: 0,
          visibility: 0.9,
          presence: 0.9,
        ),
      ),
      worldLandmarks: const [],
      processedFps: 20,
      droppedFrames: 0,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 240,
          height: 320,
          child: SkeletonOverlay(result: result),
        ),
      ),
    );

    expect(find.byKey(const Key('skeleton-overlay')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('low-visibility landmarks are not painted', () async {
    final hiddenImage = await _paintSkeleton(_result(visibility: 0.2));
    final visibleImage = await _paintSkeleton(_result(visibility: 0.9));

    expect(await _nonTransparentPixels(hiddenImage), 0);
    expect(await _nonTransparentPixels(visibleImage), greaterThan(0));
  });

  test('debug overlay is disabled for non-debug builds', () {
    expect(
      poseDebugOverlayEnabled(requested: true, isDebugBuild: false),
      isFalse,
    );
    expect(
      poseDebugOverlayEnabled(requested: true, isDebugBuild: true),
      isTrue,
    );
  });
}

PoseResult _result({required double visibility}) => PoseResult(
  timestampMs: 1,
  imageWidth: 480,
  imageHeight: 640,
  rotation: 0,
  lensDirection: CameraLensDirection.back,
  inferenceLatencyMs: 40,
  poseDetected: true,
  status: PoseStatus.poseDetected,
  landmarks: List.generate(
    33,
    (index) => PoseLandmark(
      index: index,
      x: 0.2 + (index % 5) * 0.1,
      y: 0.1 + (index ~/ 5) * 0.1,
      z: 0,
      visibility: visibility,
      presence: visibility,
    ),
  ),
  worldLandmarks: const [],
  processedFps: 20,
  droppedFrames: 0,
);

Future<ui.Image> _paintSkeleton(PoseResult result) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  SkeletonPainter(result).paint(canvas, const Size(240, 320));
  return recorder.endRecording().toImage(240, 320);
}

Future<int> _nonTransparentPixels(ui.Image image) async {
  final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  var count = 0;
  for (var index = 3; index < bytes!.lengthInBytes; index += 4) {
    if (bytes.getUint8(index) != 0) count += 1;
  }
  image.dispose();
  return count;
}
