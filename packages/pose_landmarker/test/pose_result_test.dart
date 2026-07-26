import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pose_landmarker/pose_landmarker.dart';

void main() {
  test('parses structured native pose result', () {
    final result = PoseResult.fromMap({
      'timestamp': 42,
      'imageWidth': 480,
      'imageHeight': 640,
      'rotation': 0,
      'lensDirection': 'front',
      'inferenceLatencyMs': 35.5,
      'poseDetected': true,
      'status': 'poseDetected',
      'landmarks': [
        {
          'index': 0,
          'x': 0.25,
          'y': 0.5,
          'z': -0.1,
          'visibility': 0.9,
          'presence': 0.8,
        },
      ],
      'worldLandmarks': <Object?>[],
      'processedFps': 18.2,
      'droppedFrames': 3,
    });

    expect(result.status, PoseStatus.poseDetected);
    expect(result.mirrored, isTrue);
    expect(result.landmarks.single.visibility, 0.9);
    expect(result.droppedFrames, 3);
  });

  test('coordinate mapping mirrors front camera', () {
    const landmark = PoseLandmark(
      index: 0,
      x: 0.25,
      y: 0.5,
      z: 0,
      visibility: 1,
      presence: 1,
    );

    expect(
      landmark.toPreviewOffset(const Size(200, 100), mirrored: true),
      const Offset(150, 50),
    );
  });

  test('coordinate mapping handles quarter rotation', () {
    const landmark = PoseLandmark(
      index: 0,
      x: 0.2,
      y: 0.3,
      z: 0,
      visibility: 1,
      presence: 1,
    );

    expect(
      landmark.toPreviewOffset(
        const Size(100, 100),
        mirrored: false,
        rotation: 90,
      ),
      const Offset(70, 20),
    );
  });

  test('back-camera coordinate mapping is not mirrored', () {
    const landmark = PoseLandmark(
      index: 0,
      x: 0.25,
      y: 0.5,
      z: 0,
      visibility: 1,
      presence: 1,
    );

    expect(
      landmark.toPreviewOffset(const Size(200, 100), mirrored: false),
      const Offset(50, 50),
    );
  });
}
