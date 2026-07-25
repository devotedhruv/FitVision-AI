import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.helper,
  });
  final String label;
  final String value;
  final IconData icon;
  final String? helper;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label, $value${helper == null ? '' : ', $helper'}',
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label),
            if (helper != null)
              Text(helper!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ),
  );
}
