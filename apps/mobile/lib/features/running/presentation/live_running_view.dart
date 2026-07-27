import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/models/running_status.dart';
import 'running_providers.dart';
import 'running_view_model.dart';
import 'widgets/route_map.dart';

/// Full-screen live run experience.
///
/// The map remains the primary surface while the run controls sit in a
/// lightweight bottom sheet, matching the compact layout used by native
/// fitness apps.
class LiveRunningView extends ConsumerWidget {
  const LiveRunningView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(runningViewModelProvider);
    final media = MediaQuery.of(context);
    final topInset = media.padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.go('/running/setup');
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                child: RouteMap(
                  points: vm.session?.routePoints ?? const [],
                  expand: true,
                  statusMessage: vm.message,
                ),
              ),
              Positioned(
                top: topInset + 16,
                left: 20,
                child: _MapButton(
                  icon: Icons.camera_alt_rounded,
                  tooltip: 'Camera',
                  onPressed: () {},
                ),
              ),
              Positioned(
                top: topInset + 16,
                right: 20,
                child: _MapButton(
                  icon: Icons.navigation_rounded,
                  tooltip: 'Center on location',
                  onPressed: () {},
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _RunSheet(
                  vm: vm,
                  onFinished: (id) {
                    if (context.mounted && id != null) {
                      context.go('/running/result', extra: id);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 5,
    shadowColor: Colors.black26,
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        width: 64,
        height: 64,
        child: Tooltip(
          message: tooltip,
          child: Icon(icon, size: 30, color: Colors.black),
        ),
      ),
    ),
  );
}

class _RunSheet extends StatelessWidget {
  const _RunSheet({required this.vm, required this.onFinished});

  final RunningViewModel vm;
  final ValueChanged<String?> onFinished;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final metrics = vm.metrics;
    final paused = vm.status == RunningStatus.paused;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 7,
            decoration: BoxDecoration(
              color: Color(0xFFD7D7D7),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  value: _miles(metrics.totalAcceptedDistanceMeters),
                  label: 'Distance (mi)',
                ),
              ),
              Container(width: 1, height: 54, color: const Color(0xFFE5E5E5)),
              Expanded(
                child: _Metric(
                  value: _duration(metrics.activeDuration),
                  label: 'Duration',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: FilledButton.icon(
              onPressed: vm.busy
                  ? null
                  : vm.status == RunningStatus.paused
                  ? vm.resume
                  : vm.pause,
              icon: Icon(
                paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                size: 30,
              ),
              label: Text(
                paused ? 'RESUME' : 'PAUSE',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF247CF2),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: vm.busy ? null : () => _finish(context),
              icon: const Icon(
                Icons.stop_rounded,
                color: Color(0xFFE84235),
                size: 21,
              ),
              label: const Text(
                'FINISH',
                style: TextStyle(
                  color: Color(0xFFE84235),
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF6A5F), width: 1.5),
                shape: const StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finish(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Finish run?'),
        content: const Text('Your run will be saved on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
    if (ok == true) onFinished(await vm.finish());
  }

  static String _miles(double meters) => (meters / 1609.344).toStringAsFixed(1);

  static String _duration(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 44,
          height: .98,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: -2,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xFF777777),
          letterSpacing: .2,
        ),
      ),
    ],
  );
}
