import 'package:flutter/material.dart';
import '../../domain/models/history_filter.dart';

class HistoryFilterSheet extends StatefulWidget {
  const HistoryFilterSheet({required this.initial, super.key});
  final HistoryFilter initial;
  @override
  State<HistoryFilterSheet> createState() => _HistoryFilterSheetState();
}

class _HistoryFilterSheetState extends State<HistoryFilterSheet> {
  late HistoryFilter value;
  @override
  void initState() {
    super.initState();
    value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(
              'Date',
              value.datePreset,
              HistoryDatePreset.values,
              (v) => value = value.copyWith(datePreset: v),
            ),
            _field(
              'Session type',
              value.category,
              HistoryCategoryFilter.values,
              (v) => value = value.copyWith(category: v),
            ),
            _field(
              'Exercise',
              value.exercise,
              HistoryExerciseFilter.values,
              (v) => value = value.copyWith(exercise: v),
            ),
            _field(
              'Sync',
              value.sync,
              HistorySyncFilter.values,
              (v) => value = value.copyWith(sync: v),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, value),
              child: const Text('Apply filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field<T extends Enum>(
    String label,
    T current,
    List<T> values,
    ValueChanged<T> change,
  ) => DropdownButtonFormField<T>(
    initialValue: current,
    decoration: InputDecoration(labelText: label),
    items: values
        .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
        .toList(),
    onChanged: (v) {
      if (v != null) setState(() => change(v));
    },
  );
}
