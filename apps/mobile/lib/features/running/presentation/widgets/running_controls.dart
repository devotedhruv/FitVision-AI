import 'package:flutter/material.dart';

class RunningControls extends StatelessWidget {
  const RunningControls({
    required this.paused,
    required this.busy,
    required this.onPauseResume,
    required this.onFinish,
    super.key,
  });
  final bool paused, busy;
  final VoidCallback onPauseResume, onFinish;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: FilledButton.tonalIcon(
          onPressed: busy ? null : onPauseResume,
          icon: Icon(paused ? Icons.play_arrow : Icons.pause),
          label: Text(paused ? 'Resume' : 'Pause'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: FilledButton.icon(
          onPressed: busy ? null : onFinish,
          icon: const Icon(Icons.stop),
          label: const Text('Finish'),
        ),
      ),
    ],
  );
}
