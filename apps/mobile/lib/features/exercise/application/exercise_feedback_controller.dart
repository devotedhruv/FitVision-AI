import 'dart:async';
import 'package:exercise_engine/exercise_engine.dart';
import 'package:flutter/services.dart';

abstract final class ExerciseFeedbackText {
  static String forCode(FeedbackCode code) => switch (code) {
    FeedbackCode.repCompleted => 'Rep completed',
    FeedbackCode.squatGoLower ||
    FeedbackCode.pushupGoLower => 'Go slightly lower',
    FeedbackCode.squatReturnToStanding ||
    FeedbackCode.pushupFullyExtendArms => 'Return to the starting position',
    FeedbackCode.curlFullyExtendArm => 'Fully extend your arm',
    FeedbackCode.curlCompleteContraction => 'Complete the curl',
    FeedbackCode.curlKeepUpperArmStable => 'Keep your upper arm steady',
    FeedbackCode.pushupKeepBodyAligned => 'Keep a steady body line',
    FeedbackCode.squatKeepBodyVisible ||
    FeedbackCode.pushupKeepBodyVisible ||
    FeedbackCode.fullBodyNotVisible => 'Keep your full body visible',
    FeedbackCode.curlKeepArmVisible ||
    FeedbackCode.upperBodyNotVisible => 'Keep your arm visible',
    FeedbackCode.lowerBodyNotVisible => 'Keep your lower body visible',
    FeedbackCode.sideViewRequired ||
    FeedbackCode.pushupSideViewRequired => 'Use a clear side view',
    FeedbackCode.trackingLost ||
    FeedbackCode.lowLandmarkConfidence => 'Move fully into position',
    FeedbackCode.squatIncompleteRep ||
    FeedbackCode.curlIncompleteRep ||
    FeedbackCode.pushupIncompleteRep => 'Complete the full movement',
    _ => 'Move steadily through the exercise',
  };
}

class ExerciseFeedbackController {
  bool _effectBusy = false;
  Future<void> handle(
    List<FeedbackCode> codes, {
    required bool audio,
    required bool haptics,
    required bool active,
  }) async {
    if (!active || codes.isEmpty || _effectBusy) return;
    final completed = codes.contains(FeedbackCode.repCompleted);
    final trackingLost = codes.contains(FeedbackCode.trackingLost);
    if (!completed && !trackingLost) return;
    _effectBusy = true;
    try {
      if (haptics) {
        await (completed
            ? HapticFeedback.mediumImpact()
            : HapticFeedback.selectionClick());
      }
      if (audio && completed) await SystemSound.play(SystemSoundType.click);
    } finally {
      _effectBusy = false;
    }
  }
}
