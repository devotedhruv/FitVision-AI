import 'package:flutter/material.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'No sessions match these filters.',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
