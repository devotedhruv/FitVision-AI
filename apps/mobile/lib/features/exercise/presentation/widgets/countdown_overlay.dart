import 'package:flutter/material.dart';

class CountdownOverlay extends StatelessWidget {
  const CountdownOverlay({
    required this.count,
    required this.onCancel,
    super.key,
  });

  final int count;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: ColoredBox(
      color: Colors.black54,
      child: Semantics(
        liveRegion: true,
        label: 'Exercise starts in $count',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              key: const Key('countdown-value'),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Get ready', style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: onCancel,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
