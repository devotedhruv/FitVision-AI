import 'dart:math' as math;

import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

enum ExerciseMotion {
  squat,
  pushUp,
  bicepCurl,
  shoulderPress,
  lunge,
  plank,
  jumpingJack,
  fallback,
}

class ExerciseAnimationSpec {
  const ExerciseAnimationSpec({
    required this.exerciseId,
    required this.motion,
    required this.description,
    this.duration = const Duration(milliseconds: 1800),
    this.loop = true,
  });

  final String exerciseId;
  final ExerciseMotion motion;
  final String description;
  final Duration duration;
  final bool loop;
}

abstract final class ExerciseAnimationRegistry {
  static const _specs = <String, ExerciseAnimationSpec>{
    'squat': ExerciseAnimationSpec(
      exerciseId: 'squat',
      motion: ExerciseMotion.squat,
      description:
          'Standing tall, lowering the hips into a squat, then returning to stand.',
    ),
    'push-up': ExerciseAnimationSpec(
      exerciseId: 'push-up',
      motion: ExerciseMotion.pushUp,
      description:
          'Holding a straight body line, lowering toward the floor, then pressing up.',
    ),
    'bicep-curl': ExerciseAnimationSpec(
      exerciseId: 'bicep-curl',
      motion: ExerciseMotion.bicepCurl,
      description:
          'Keeping the elbow close to the body while curling and lowering the forearm.',
    ),
    'shoulder-press': ExerciseAnimationSpec(
      exerciseId: 'shoulder-press',
      motion: ExerciseMotion.shoulderPress,
      description:
          'Pressing both hands overhead, then returning them to shoulder height.',
    ),
    'lunges': ExerciseAnimationSpec(
      exerciseId: 'lunges',
      motion: ExerciseMotion.lunge,
      description:
          'Stepping forward, lowering both knees with control, then returning to stand.',
    ),
    'plank': ExerciseAnimationSpec(
      exerciseId: 'plank',
      motion: ExerciseMotion.plank,
      description:
          'Holding a steady straight line from the shoulders through the ankles.',
      duration: Duration(milliseconds: 2400),
    ),
    'jumping-jack': ExerciseAnimationSpec(
      exerciseId: 'jumping-jack',
      motion: ExerciseMotion.jumpingJack,
      description:
          'Moving the feet apart as both arms rise, then returning softly to the start.',
      duration: Duration(milliseconds: 1400),
    ),
  };

  static ExerciseAnimationSpec resolve(String exerciseId) =>
      _specs[exerciseId] ??
      ExerciseAnimationSpec(
        exerciseId: exerciseId,
        motion: ExerciseMotion.fallback,
        description:
            'Follow the written movement instructions at a comfortable pace.',
        loop: false,
      );

  static bool supports(String exerciseId) => _specs.containsKey(exerciseId);
  static Set<String> get supportedIds => Set.unmodifiable(_specs.keys);
}

class ExerciseAnimation extends StatefulWidget {
  const ExerciseAnimation({
    required this.exerciseId,
    super.key,
    this.autoPlay = false,
    this.compact = false,
    this.showControls = true,
  });

  final String exerciseId;
  final bool autoPlay;
  final bool compact;
  final bool showControls;

  @override
  State<ExerciseAnimation> createState() => _ExerciseAnimationState();
}

class _ExerciseAnimationState extends State<ExerciseAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  bool get _reduceMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  bool get _playing => _controller?.isAnimating ?? false;
  ExerciseAnimationSpec get _spec =>
      ExerciseAnimationRegistry.resolve(widget.exerciseId);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autoPlay && !_reduceMotion) _play();
    if (_reduceMotion) _controller?.stop();
  }

  @override
  void didUpdateWidget(covariant ExerciseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseId != widget.exerciseId) {
      _controller?.dispose();
      _controller = null;
      if (widget.autoPlay && !_reduceMotion) _play();
    }
  }

  void _play() {
    if (_reduceMotion) return;
    final controller = _controller ??=
        AnimationController(vsync: this, duration: _spec.duration)
          ..addStatusListener((_) {
            if (mounted) setState(() {});
          });
    if (_spec.loop) {
      controller.repeat(reverse: true);
    } else {
      controller.forward(from: 0);
    }
    setState(() {});
  }

  void _pause() {
    _controller?.stop();
    setState(() {});
  }

  void _replay() {
    _controller?.reset();
    _play();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label:
          '${widget.exerciseId} movement demonstration. ${_spec.description}',
      image: true,
      child: RepaintBoundary(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [scheme.primaryContainer, scheme.secondaryContainer],
            ),
            borderRadius: BorderRadius.circular(
              widget.compact ? AppRadius.medium : AppRadius.extraLarge,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: _controller ?? const AlwaysStoppedAnimation(0),
                builder: (_, _) => CustomPaint(
                  painter: _ExercisePainter(
                    motion: _spec.motion,
                    progress: _controller?.value ?? .08,
                    color: scheme.onPrimaryContainer,
                    accent: scheme.primary,
                  ),
                ),
              ),
              if (widget.showControls)
                Positioned(
                  right: widget.compact ? 4 : AppSpacing.sm,
                  bottom: widget.compact ? 4 : AppSpacing.sm,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!widget.compact && !_playing)
                        IconButton.filledTonal(
                          tooltip: 'Replay demonstration',
                          onPressed: _replay,
                          icon: const Icon(Icons.replay),
                        ),
                      IconButton.filled(
                        tooltip: _reduceMotion
                            ? 'Animation disabled by reduced motion setting'
                            : _playing
                            ? 'Pause demonstration'
                            : 'Play demonstration',
                        onPressed: _reduceMotion
                            ? null
                            : _playing
                            ? _pause
                            : _play,
                        icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisePainter extends CustomPainter {
  const _ExercisePainter({
    required this.motion,
    required this.progress,
    required this.color,
    required this.accent,
  });

  final ExerciseMotion motion;
  final double progress;
  final Color color;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final t = Curves.easeInOut.transform(progress);
    final line = Paint()
      ..color = color
      ..strokeWidth = math.max(3, size.shortestSide * .035)
      ..strokeCap = StrokeCap.round;
    final joint = Paint()..color = accent;
    final points = _points(t);
    Offset p(String key) =>
        Offset(points[key]!.$1 * size.width, points[key]!.$2 * size.height);
    void bone(String a, String b) => canvas.drawLine(p(a), p(b), line);
    for (final pair in const [
      ('neck', 'hip'),
      ('neck', 'leftElbow'),
      ('leftElbow', 'leftHand'),
      ('neck', 'rightElbow'),
      ('rightElbow', 'rightHand'),
      ('hip', 'leftKnee'),
      ('leftKnee', 'leftFoot'),
      ('hip', 'rightKnee'),
      ('rightKnee', 'rightFoot'),
    ]) {
      bone(pair.$1, pair.$2);
    }
    canvas.drawCircle(
      p('head'),
      math.max(6, size.shortestSide * .075),
      line..style = PaintingStyle.stroke,
    );
    for (final name in const [
      'neck',
      'leftElbow',
      'rightElbow',
      'hip',
      'leftKnee',
      'rightKnee',
    ]) {
      canvas.drawCircle(p(name), math.max(2, size.shortestSide * .018), joint);
    }
  }

  Map<String, (double, double)> _points(double t) {
    switch (motion) {
      case ExerciseMotion.squat:
        final down = .22 * t;
        return _standing(
          headY: .18 + down,
          neckY: .3 + down,
          hipY: .52 + down,
          leftKnee: (.35, .7 + down * .25),
          rightKnee: (.65, .7 + down * .25),
          leftFoot: (.27, .9),
          rightFoot: (.73, .9),
        );
      case ExerciseMotion.pushUp:
        final y = .4 + .16 * t;
        return _horizontal(y, bentArms: t);
      case ExerciseMotion.bicepCurl:
        final handY = .68 - .3 * t;
        return _standing(
          leftElbow: (.35, .52),
          rightElbow: (.65, .52),
          leftHand: (.3 + .08 * t, handY),
          rightHand: (.7 - .08 * t, handY),
        );
      case ExerciseMotion.shoulderPress:
        final y = .48 - .32 * t;
        return _standing(
          leftElbow: (.34, .42 - .13 * t),
          rightElbow: (.66, .42 - .13 * t),
          leftHand: (.34, y),
          rightHand: (.66, y),
        );
      case ExerciseMotion.lunge:
        final down = .16 * t;
        return _standing(
          headY: .18 + down,
          neckY: .3 + down,
          hipY: .52 + down,
          leftKnee: (.32 - .12 * t, .72),
          rightKnee: (.63 + .12 * t, .72 + .12 * t),
          leftFoot: (.2 - .08 * t, .9),
          rightFoot: (.78, .9),
        );
      case ExerciseMotion.plank:
        return _horizontal(.48 + math.sin(t * math.pi) * .012, bentArms: 1);
      case ExerciseMotion.jumpingJack:
        return _standing(
          leftElbow: (.38 - .2 * t, .45 - .2 * t),
          rightElbow: (.62 + .2 * t, .45 - .2 * t),
          leftHand: (.35 - .3 * t, .62 - .52 * t),
          rightHand: (.65 + .3 * t, .62 - .52 * t),
          leftKnee: (.43 - .1 * t, .7),
          rightKnee: (.57 + .1 * t, .7),
          leftFoot: (.42 - .24 * t, .9),
          rightFoot: (.58 + .24 * t, .9),
        );
      case ExerciseMotion.fallback:
        return _standing();
    }
  }

  Map<String, (double, double)> _standing({
    double headY = .18,
    double neckY = .3,
    double hipY = .52,
    (double, double) leftElbow = const (.36, .48),
    (double, double) rightElbow = const (.64, .48),
    (double, double) leftHand = const (.32, .66),
    (double, double) rightHand = const (.68, .66),
    (double, double) leftKnee = const (.43, .72),
    (double, double) rightKnee = const (.57, .72),
    (double, double) leftFoot = const (.4, .9),
    (double, double) rightFoot = const (.6, .9),
  }) => {
    'head': (.5, headY),
    'neck': (.5, neckY),
    'hip': (.5, hipY),
    'leftElbow': leftElbow,
    'rightElbow': rightElbow,
    'leftHand': leftHand,
    'rightHand': rightHand,
    'leftKnee': leftKnee,
    'rightKnee': rightKnee,
    'leftFoot': leftFoot,
    'rightFoot': rightFoot,
  };

  Map<String, (double, double)> _horizontal(
    double y, {
    required double bentArms,
  }) => {
    'head': (.18, y - .06),
    'neck': (.27, y),
    'hip': (.58, y + .04),
    'leftElbow': (.32, .66 - .08 * bentArms),
    'rightElbow': (.34, .64 - .06 * bentArms),
    'leftHand': (.27, .78),
    'rightHand': (.4, .78),
    'leftKnee': (.74, y + .07),
    'rightKnee': (.76, y + .09),
    'leftFoot': (.9, y + .11),
    'rightFoot': (.92, y + .13),
  };

  @override
  bool shouldRepaint(covariant _ExercisePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.motion != motion ||
      oldDelegate.color != color ||
      oldDelegate.accent != accent;
}
