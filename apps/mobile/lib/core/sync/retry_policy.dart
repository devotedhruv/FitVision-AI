import 'dart:math';

class RetryPolicy {
  RetryPolicy({
    this.baseDelay = const Duration(seconds: 5),
    this.maximumDelay = const Duration(minutes: 15),
    this.maximumAttempts = 8,
    Random? random,
  }) : _random = random ?? Random.secure();
  final Duration baseDelay;
  final Duration maximumDelay;
  final int maximumAttempts;
  final Random _random;

  Duration delayForAttempt(int attempt) {
    final exponent = attempt <= 1 ? 0 : attempt - 1;
    final uncapped = baseDelay.inMilliseconds * pow(3, exponent);
    final capped = min(uncapped.toInt(), maximumDelay.inMilliseconds);
    final jitter = (capped * .2 * _random.nextDouble()).round();
    return Duration(milliseconds: capped + jitter);
  }

  bool canRetry(int attempt) => attempt < maximumAttempts;
}
