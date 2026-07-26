import 'package:exercise_engine/exercise_engine.dart';
import 'pose_fixture.dart';

List<PoseFrame> completePushup({double alignment = 180}) =>
    cycle(ExerciseType.pushup, [170, 130, 65, 120, 170], alignment: alignment);
