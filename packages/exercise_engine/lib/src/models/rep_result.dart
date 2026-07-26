import '../feedback/feedback_code.dart';

class RepResult {
  const RepResult({
    required this.repNumber,
    required this.startTime,
    required this.endTime,
    required this.completed,
    required this.formValid,
    required this.feedbackCodes,
    this.minimumAngle,
    this.maximumAngle,
    this.qualityScore,
  });
  final int repNumber;
  final Duration startTime;
  final Duration endTime;
  Duration get duration => endTime - startTime;
  final bool completed;
  final bool formValid;
  final List<FeedbackCode> feedbackCodes;
  final double? minimumAngle;
  final double? maximumAngle;
  final double? qualityScore;
}
