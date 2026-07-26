import 'package:exercise_engine/exercise_engine.dart';
import 'package:test/test.dart';
import 'fixtures/curl_sequences.dart';
import 'fixtures/pose_fixture.dart';

void main() {
  test('Given full extension-contraction-extension, one curl counts', () {
    final a = CurlAnalyzer();
    for (final f in completeCurl()) {
      a.processFrame(f);
    }
    expect(a.finishSession().completedRepCount, 1);
  });
  test('Given a contracted hold, it does not add curls', () {
    final a = CurlAnalyzer();
    for (final f in cycle(ExerciseType.bicepsCurl, [170, 120, 35, 35, 35])) {
      a.processFrame(f);
    }
    expect(a.finishSession().completedRepCount, 0);
  });
  test('Given a partial curl, it is incomplete and does not count', () {
    final analyzer = CurlAnalyzer();
    for (final frame in cycle(ExerciseType.bicepsCurl, [170, 120, 170])) {
      analyzer.processFrame(frame);
    }
    final result = analyzer.finishSession();
    expect(result.completedRepCount, 0);
    expect(result.incompleteRepCount, 1);
  });
  test('Given material elbow displacement, upper-arm feedback is produced', () {
    final analyzer = CurlAnalyzer();
    analyzer.processFrame(jointFrame(100, 170, type: ExerciseType.bicepsCurl));
    final outputs = <AnalyzerOutput>[];
    for (var index = 0; index < 12; index++) {
      outputs.add(
        analyzer.processFrame(
          jointFrame(
            200 + index * 100,
            120,
            type: ExerciseType.bicepsCurl,
            elbowShift: .12,
          ),
        ),
      );
    }
    expect(
      outputs.expand((output) => output.feedbackCodes),
      contains(FeedbackCode.curlKeepUpperArmStable),
    );
  });
  test('Given noise around one threshold, no curl is double-counted', () {
    final analyzer = CurlAnalyzer();
    for (final frame in cycle(ExerciseType.bicepsCurl, [
      170,
      146,
      144,
      146,
      144,
      170,
    ])) {
      analyzer.processFrame(frame);
    }
    expect(analyzer.finishSession().completedRepCount, 0);
  });
  test(
    'Given unequal side confidence, the stronger side is selected stably',
    () {
      final a = CurlAnalyzer();
      a.processFrame(jointFrame(100, 170, type: ExerciseType.bicepsCurl));
      expect(a.selectedSide, isNotNull);
    },
  );
}
