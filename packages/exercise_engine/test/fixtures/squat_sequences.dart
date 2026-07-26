import 'package:exercise_engine/exercise_engine.dart';
import 'pose_fixture.dart';

List<PoseFrame> completeSquat() =>
    cycle(ExerciseType.squat, [170, 140, 80, 120, 170]);
List<PoseFrame> partialSquat() => cycle(ExerciseType.squat, [170, 140, 170]);
