import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RunningSetupView extends StatelessWidget {
  const RunningSetupView({super.key});
  @override
  Widget build(BuildContext context) => _BoundaryScaffold(
    title: 'Running setup',
    icon: Icons.directions_run,
    message:
        'GPS and location permission are intentionally unavailable until the '
        'running-tracking phase.',
    action: FilledButton(
      onPressed: () => context.push('/running/live'),
      child: const Text('Preview running screen'),
    ),
  );
}

class LiveRunningView extends StatelessWidget {
  const LiveRunningView({super.key});
  @override
  Widget build(BuildContext context) => _BoundaryScaffold(
    title: 'Live running',
    icon: Icons.map_outlined,
    message:
        'No live position is displayed. Real GPS tracking belongs to a later phase.',
    action: FilledButton(
      onPressed: () => context.push('/running/result'),
      child: const Text('View unavailable result'),
    ),
  );
}

class RunningResultView extends StatelessWidget {
  const RunningResultView({super.key});
  @override
  Widget build(BuildContext context) => const _BoundaryScaffold(
    title: 'Running result',
    icon: Icons.route_outlined,
    message: 'No fake distance, pace, route or GPS result has been generated.',
  );
}

class SessionDetailView extends StatelessWidget {
  const SessionDetailView({required this.sessionId, super.key});
  final String sessionId;
  @override
  Widget build(BuildContext context) => _BoundaryScaffold(
    title: 'Session details',
    icon: Icons.history,
    message: sessionId.isEmpty
        ? 'The requested session is invalid.'
        : 'Detailed synchronized session display is reserved for a real backend record.',
  );
}

class _BoundaryScaffold extends StatelessWidget {
  const _BoundaryScaffold({
    required this.title,
    required this.icon,
    required this.message,
    this.action,
  });
  final String title;
  final IconData icon;
  final String message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 72),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (action case final widget?) ...[
              const SizedBox(height: 16),
              widget,
            ],
          ],
        ),
      ),
    ),
  );
}
