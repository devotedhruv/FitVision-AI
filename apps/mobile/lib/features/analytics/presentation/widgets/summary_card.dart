import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
