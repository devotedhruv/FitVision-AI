import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailVerificationView extends ConsumerWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Verify your email')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 56),
            const SizedBox(height: 16),
            const Text(
              'Open the verification email from Supabase, then return to the app.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => ref.read(authViewModelProvider).logout(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    ),
  );
}
