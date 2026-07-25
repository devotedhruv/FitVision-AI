export 'app_error_view.dart' show AppErrorView;

import 'package:fitvision_ai/shared/widgets/app_error_view.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    super.key,
    this.actionLabel,
    this.onRetry,
  });
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppErrorView(
    message: message,
    actionLabel: actionLabel,
    onRetry: onRetry,
  );
}
