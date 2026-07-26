import 'package:flutter/material.dart';
import '../../domain/models/analytics_period.dart';

class AnalyticsPeriodSelector extends StatelessWidget {
  const AnalyticsPeriodSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });
  final AnalyticsPeriodType value;
  final ValueChanged<AnalyticsPeriodType> onChanged;
  @override
  Widget build(BuildContext context) => SegmentedButton(
    segments: AnalyticsPeriodType.values
        .map((v) => ButtonSegment(value: v, label: Text(v.name)))
        .toList(),
    selected: {value},
    onSelectionChanged: (s) => onChanged(s.first),
  );
}
