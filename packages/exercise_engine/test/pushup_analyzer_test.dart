import 'package:exercise_engine/exercise_engine.dart';
import 'package:test/test.dart';
import 'fixtures/pushup_sequences.dart';
import 'fixtures/pose_fixture.dart';

void main() {
  test('Given a full top-bottom-top cycle, one push-up counts', () {
    final a = PushupAnalyzer();
    for (final f in completePushup()) {
      a.processFrame(f);
    }
    expect(a.finishSession().completedRepCount, 1);
  });
  test('Given partial elbow movement, no push-up counts', () {
    final a = PushupAnalyzer();
    for (final f in cycle(ExerciseType.pushup, [170, 130, 170])) {
      a.processFrame(f);
    }
    expect(a.finishSession().completedRepCount, 0);
  });
  test('Given a bottom hold, it does not add push-ups', () {
    final analyzer = PushupAnalyzer();
    for (final frame in cycle(ExerciseType.pushup, [170, 130, 65, 65, 65])) {
      analyzer.processFrame(frame);
    }
    expect(analyzer.finishSession().completedRepCount, 0);
  });
  test('Given threshold noise, no push-up is double-counted', () {
    final analyzer = PushupAnalyzer();
    for (final frame in cycle(ExerciseType.pushup, [
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
  test('Given poor alignment, typed feedback is emitted safely', () {
    final a = PushupAnalyzer();
    final outputs = [
      for (final f in completePushup(alignment: 120)) a.processFrame(f),
    ];
    expect(
      outputs.expand((o) => o.feedbackCodes),
      contains(FeedbackCode.pushupKeepBodyAligned),
    );
  });
  test('Given missing hip and ankle, alignment is skipped without a crash', () {
    final a = PushupAnalyzer();
    final original = jointFrame(100, 170, type: ExerciseType.bicepsCurl);
    final f = PoseFrame(
      timestamp: original.timestamp,
      landmarks: original.landmarks.values.where(
        (landmark) => !{23, 24, 27, 28}.contains(landmark.index),
      ),
    );
    expect(a.processFrame(f).jointAngles.containsKey('bodyAlignment'), isFalse);
  });
}
