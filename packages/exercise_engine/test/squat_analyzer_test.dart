import 'package:exercise_engine/exercise_engine.dart';
import 'package:test/test.dart';
import 'fixtures/squat_sequences.dart';

void main() {
  test(
    'Given a full standing-bottom-standing cycle, exactly one squat counts',
    () {
      final analyzer = SquatAnalyzer();
      AnalyzerOutput? output;
      var completionEventSeen = false;
      for (final frame in completeSquat()) {
        output = analyzer.processFrame(frame);
        completionEventSeen = completionEventSeen || output.repCompleted;
      }
      expect(output!.totalCompletedReps, 1);
      expect(completionEventSeen, isTrue);
    },
  );
  test('Given two cycles and position holds, exactly two squats count', () {
    final analyzer = SquatAnalyzer();
    final frames = completeSquat();
    final offset = frames.last.timestamp.inMilliseconds;
    for (final frame in [
      ...frames,
      ...completeSquat().map(
        (f) => PoseFrame(
          timestamp: f.timestamp + Duration(milliseconds: offset),
          landmarks: f.landmarks.values,
        ),
      ),
    ]) {
      analyzer.processFrame(frame);
    }
    expect(analyzer.finishSession().completedRepCount, 2);
  });
  test('Given a partial squat, it is incomplete and not counted', () {
    final analyzer = SquatAnalyzer();
    for (final frame in partialSquat()) {
      analyzer.processFrame(frame);
    }
    final result = analyzer.finishSession();
    expect(result.completedRepCount, 0);
    expect(result.incompleteRepCount, 1);
  });
  test('Given pause and resume, no false squat is created', () {
    final analyzer = SquatAnalyzer()..pause();
    for (final frame in completeSquat()) {
      analyzer.processFrame(frame);
    }
    analyzer.resume();
    expect(analyzer.finishSession().completedRepCount, 0);
  });
  test('Given a rejected frame, the rep state does not change', () {
    final analyzer = SquatAnalyzer();
    final before = analyzer.processFrame(completeSquat().first);
    final source = completeSquat()[10];
    final rejected = PoseFrame(
      timestamp: source.timestamp,
      landmarks: source.landmarks.values.map(
        (item) => PoseLandmark(
          index: item.index,
          x: item.x,
          y: item.y,
          visibility: .2,
        ),
      ),
    );
    final after = analyzer.processFrame(rejected);
    expect(after.trackingStatus.accepted, isFalse);
    expect(after.currentState, before.currentState);
    expect(after.totalCompletedReps, 0);
  });
  test('Given prolonged tracking loss, an active squat becomes incomplete', () {
    final analyzer = SquatAnalyzer();
    final frames = completeSquat();
    for (final frame in frames.take(20)) {
      analyzer.processFrame(frame);
    }
    final source = frames[19];
    final lost = PoseFrame(
      timestamp: source.timestamp + const Duration(seconds: 1),
      landmarks: source.landmarks.values.map(
        (item) => PoseLandmark(
          index: item.index,
          x: item.x,
          y: item.y,
          visibility: .1,
        ),
      ),
    );
    final output = analyzer.processFrame(lost);
    expect(output.incompleteRepDetected, isTrue);
    expect(analyzer.finishSession().incompleteRepCount, 1);
  });
}
