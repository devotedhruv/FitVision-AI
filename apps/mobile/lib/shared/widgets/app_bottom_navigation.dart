import 'package:fitvision_ai/core/design_system/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(AppIcons.home),
            selectedIcon: Icon(AppIcons.homeSelected),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.exercises),
            selectedIcon: Icon(AppIcons.exercisesSelected),
            label: 'Exercises',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.running),
            selectedIcon: Icon(AppIcons.runningSelected),
            label: 'Running',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.history),
            selectedIcon: Icon(AppIcons.historySelected),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.profile),
            selectedIcon: Icon(AppIcons.profileSelected),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );
}
