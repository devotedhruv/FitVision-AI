import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextStyle? display(BuildContext context) => Theme.of(context)
      .textTheme
      .displaySmall
      ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.2);

  static TextStyle? pageTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700);

  static TextStyle? sectionTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);

  static TextStyle? cardTitle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);

  static TextStyle? metric(BuildContext context) => Theme.of(context)
      .textTheme
      .headlineSmall
      ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5);

  static TextStyle? caption(BuildContext context) => Theme.of(context)
      .textTheme
      .bodySmall
      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

  static TextStyle? button(BuildContext context) => Theme.of(context)
      .textTheme
      .labelLarge
      ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.1);
}
