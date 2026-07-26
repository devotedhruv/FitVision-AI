import 'package:flutter/material.dart';
import '../../domain/calculations/pace_calculator.dart';

class PaceDisplay extends StatelessWidget {
  const PaceDisplay({required this.pace, super.key});
  final double? pace;
  @override
  Widget build(BuildContext context) => Text(
    '${PaceCalculator.format(pace)} /km',
    style: Theme.of(context).textTheme.headlineMedium,
  );
}
