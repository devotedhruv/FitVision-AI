import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:fitvision_ai/core/utils/date_time_formatter.dart';
import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:fitvision_ai/features/exercise/models/exercise.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view_model.dart';
import 'package:fitvision_ai/features/exercise/presentation/widgets/countdown_overlay.dart';
import 'package:fitvision_ai/features/exercise/presentation/widgets/skeleton_overlay.dart';
import 'package:fitvision_ai/features/exercise/presentation/widgets/tracking_status_badge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pose_landmarker/pose_landmarker.dart';

class LiveExerciseView extends ConsumerWidget {
  const LiveExerciseView({required this.exercise, super.key});
  final Exercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(liveExerciseProvider);
    final controller = ref.read(liveExerciseProvider.notifier);
    if (session.stage == LivePoseStage.guide ||
        (session.stage == LivePoseStage.error &&
            session.permission != CameraPermissionState.granted)) {
      return _CameraGuide(
        exercise: exercise,
        state: session,
        onStart: controller.initializeCamera,
        onSettings: controller.openSettings,
      );
    }
    return PopScope(
      canPop: session.stage == LivePoseStage.completed,
      onPopInvokedWithResult: (didPop, _) async {
        final confirmed = !didPop && await _confirmEnd(context);
        if (confirmed && context.mounted) {
          await _endAndNavigate(context, controller, session);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(exercise.name),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: session.frontCamera
                  ? 'Use back camera'
                  : 'Use front camera',
              onPressed:
                  session.stage == LivePoseStage.active ||
                      session.stage == LivePoseStage.countdown
                  ? null
                  : controller.switchCamera,
              icon: const Icon(Icons.cameraswitch_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PoseCameraView(frontCamera: session.frontCamera),
                    SkeletonOverlay(
                      result: session.latestPose,
                      showDebug: kDebugMode && session.debugOverlay,
                    ),
                    Positioned(
                      left: AppSpacing.sm,
                      top: AppSpacing.sm,
                      child: TrackingStatusBadge(
                        status: session.latestPose?.status,
                      ),
                    ),
                    Positioned(
                      right: AppSpacing.sm,
                      top: AppSpacing.sm,
                      child: Chip(
                        avatar: Icon(
                          session.frontCamera
                              ? Icons.camera_front
                              : Icons.camera_rear,
                          size: 18,
                        ),
                        label: Text(session.frontCamera ? 'Front' : 'Back'),
                      ),
                    ),
                    if (session.stage == LivePoseStage.countdown)
                      CountdownOverlay(
                        count: session.countdown ?? 3,
                        onCancel: controller.cancelCountdown,
                      ),
                    if (session.stage == LivePoseStage.paused)
                      const Positioned.fill(
                        child: ColoredBox(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              'PAUSED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _ControlPanel(
                state: session,
                onStart: controller.startCountdown,
                onPause: controller.pause,
                onResume: controller.resume,
                onEnd: () async {
                  if (await _confirmEnd(context) && context.mounted) {
                    await _endAndNavigate(context, controller, session);
                  }
                },
                onAudio: controller.toggleAudio,
                onHaptics: controller.toggleHaptics,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _endAndNavigate(
    BuildContext context,
    LiveExerciseViewModel controller,
    LivePoseSessionState state,
  ) async {
    await controller.end();
    if (!context.mounted) return;
    context.go(
      '/exercises/${exercise.id}/result',
      extra: WorkoutResultData(
        exerciseName: exercise.name,
        duration: state.elapsed,
        frontCamera: state.frontCamera,
        detectedFramePercentage: state.detectedFramePercentage,
        averageLatencyMs: state.averageLatencyMs,
        completed: true,
      ),
    );
  }

  Future<bool> _confirmEnd(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('End camera session?'),
          content: const Text(
            'The camera and on-device pose detector will stop.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Keep going'),
            ),
            FilledButton(
              key: const Key('confirm-end-session'),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('End session'),
            ),
          ],
        ),
      ) ??
      false;
}

class _CameraGuide extends StatelessWidget {
  const _CameraGuide({
    required this.exercise,
    required this.state,
    required this.onStart,
    required this.onSettings,
  });
  final Exercise exercise;
  final LivePoseSessionState state;
  final VoidCallback onStart;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('${exercise.name} camera guide')),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Icon(Icons.phone_android, size: 72),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Place your phone securely',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text('• Use portrait orientation and stable support.'),
        const Text('• Keep shoulders, hips, knees and ankles visible.'),
        const Text('• Face the camera with clear, even lighting.'),
        const Text('• Clear enough space to move safely.'),
        const SizedBox(height: AppSpacing.md),
        const Card(
          child: ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Private on-device processing'),
            subtitle: Text(
              'Raw camera video is neither uploaded nor saved. Only future '
              'structured workout summaries may be synchronized.',
            ),
          ),
        ),
        if (state.stage == LivePoseStage.error)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(state.feedback),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          key: const Key('enable-camera'),
          onPressed: onStart,
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Enable camera'),
        ),
        if (state.permission == CameraPermissionState.permanentlyDenied)
          TextButton(onPressed: onSettings, child: const Text('Open Settings')),
      ],
    ),
  );
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onEnd,
    required this.onAudio,
    required this.onHaptics,
  });
  final LivePoseSessionState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onEnd;
  final VoidCallback onAudio;
  final VoidCallback onHaptics;

  @override
  Widget build(BuildContext context) {
    final active = state.stage == LivePoseStage.active;
    final paused = state.stage == LivePoseStage.paused;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              child: Text(
                state.feedback,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                _Metric(
                  label: 'Stage',
                  value: state.analysis.stage.name.toUpperCase(),
                ),
                _Metric(label: 'Reps', value: '${state.analysis.repCount}'),
                _Metric(
                  label: 'Timer',
                  value: DateTimeFormatter.duration(state.elapsed),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                IconButton(
                  tooltip: 'Toggle audio feedback',
                  onPressed: onAudio,
                  icon: Icon(
                    state.audioEnabled ? Icons.volume_up : Icons.volume_off,
                  ),
                ),
                IconButton(
                  tooltip: 'Toggle haptic feedback',
                  onPressed: onHaptics,
                  icon: Icon(
                    state.hapticsEnabled
                        ? Icons.vibration
                        : Icons.phone_android,
                  ),
                ),
                const Spacer(),
                if (!active && !paused)
                  FilledButton.icon(
                    key: const Key('start-session'),
                    onPressed: state.fullBodyReady ? onStart : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  )
                else
                  FilledButton.tonalIcon(
                    key: const Key('pause-resume'),
                    onPressed: paused ? onResume : onPause,
                    icon: Icon(paused ? Icons.play_arrow : Icons.pause),
                    label: Text(paused ? 'Resume' : 'Pause'),
                  ),
                const SizedBox(width: AppSpacing.xs),
                IconButton.filled(
                  key: const Key('end-session'),
                  tooltip: 'End session',
                  onPressed: onEnd,
                  icon: const Icon(Icons.stop),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(value, maxLines: 1),
      ],
    ),
  );
}
