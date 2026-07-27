import 'package:fitvision_ai/shared/widgets/app_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (path != '/dashboard') {
            context.go('/dashboard');
          } else {
            _confirmExit(context);
          }
        }
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNavigation(
          navigationShell: widget.navigationShell,
        ),
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final exit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit FitVision AI?'),
        content: const Text('Do you want to exit this app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes, exit'),
          ),
        ],
      ),
    );
    if (exit == true && context.mounted) await SystemNavigator.pop();
  }
}
