import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextStyle? pageTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700);

  static TextStyle? sectionTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);

  static TextStyle? cardTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);
}
