import 'package:fitvision_ai/core/design_system/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Move with clarity',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Explore exercises, simulated coaching, running previews, and progress insights.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Explore demo'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
