import '../models/analyzer_output.dart';
import '../models/exercise_result.dart';
import '../models/pose_frame.dart';

abstract interface class ExerciseAnalyzer {
  AnalyzerOutput processFrame(PoseFrame frame);
  void pause();
  void resume();
  void reset();
  ExerciseResult finishSession([Duration? timestamp]);
}
