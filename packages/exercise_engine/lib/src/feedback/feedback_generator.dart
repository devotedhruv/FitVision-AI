import '../config/exercise_engine_config.dart';
import 'feedback_code.dart';

class FeedbackGenerator {
  FeedbackGenerator([this.config = const FeedbackConfig()]);
  final FeedbackConfig config;
  final Map<FeedbackCode, Duration> _lastEmitted = {};

  List<FeedbackCode> generate(
    Duration timestamp,
    Iterable<FeedbackCode> candidates, {
    Set<FeedbackCode> immediate = const {FeedbackCode.trackingLost},
  }) {
    final unique = candidates.toSet().toList()
      ..sort((a, b) => _priority(a).compareTo(_priority(b)));
    if (unique.isEmpty) return const [];
    final code = unique.first;
    final last = _lastEmitted[code];
    if (!immediate.contains(code) &&
        last != null &&
        timestamp - last < config.cooldown) {
      return const [];
    }
    _lastEmitted[code] = timestamp;
    return List.unmodifiable([code]);
  }

  void reset() => _lastEmitted.clear();
  int _priority(FeedbackCode code) => switch (code) {
    FeedbackCode.trackingLost ||
    FeedbackCode.fullBodyNotVisible ||
    FeedbackCode.upperBodyNotVisible ||
    FeedbackCode.lowerBodyNotVisible ||
    FeedbackCode.lowLandmarkConfidence => 0,
    FeedbackCode.sideViewRequired || FeedbackCode.pushupSideViewRequired => 1,
    FeedbackCode.squatIncompleteRep ||
    FeedbackCode.curlIncompleteRep ||
    FeedbackCode.pushupIncompleteRep => 2,
    FeedbackCode.repCompleted => 4,
    _ => 3,
  };
}
