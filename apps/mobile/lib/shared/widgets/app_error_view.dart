import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    super.key,
    this.actionLabel,
    this.onRetry,
  });
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
