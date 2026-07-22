import 'package:fitvision_ai/shared/widgets/app_error_view.dart';
import 'package:fitvision_ai/shared/widgets/foundation_status_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FoundationStatusPage(),
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) => const Scaffold(
        body: AppErrorView(
          message: 'This is the Phase 1 error-state demonstration.',
        ),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: AppErrorView(
      message: 'The requested page does not exist.',
      actionLabel: 'Return home',
      onRetry: () => context.go('/'),
    ),
  ),
);
