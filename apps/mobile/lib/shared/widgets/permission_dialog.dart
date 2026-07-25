import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    required this.title,
    required this.explanation,
    required this.onContinue,
    super.key,
  });
  final String title;
  final String explanation;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(title),
    content: Text(explanation),
    actionsPadding: const EdgeInsets.all(AppSpacing.md),
    actions: [
      FilledButton(onPressed: onContinue, child: const Text('Continue demo')),
    ],
  );
}
