import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordRecoveryView extends ConsumerStatefulWidget {
  const PasswordRecoveryView({super.key});

  @override
  ConsumerState<PasswordRecoveryView> createState() =>
      _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends ConsumerState<PasswordRecoveryView> {
  final email = TextEditingController();
  final code = TextEditingController();
  final password = TextEditingController();
  bool codeRequested = false;

  @override
  void dispose() {
    email.dispose();
    code.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: email,
            enabled: !codeRequested,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          if (codeRequested) ...[
            const SizedBox(height: 12),
            TextField(
              controller: code,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              decoration: const InputDecoration(labelText: 'Reset code'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: password,
              obscureText: true,
              autofillHints: const [AutofillHints.newPassword],
              decoration: const InputDecoration(labelText: 'New password'),
            ),
          ],
          if (auth.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              auth.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: auth.status == AuthStatus.loading
                ? null
                : () async {
                    if (!codeRequested) {
                      await auth.requestPasswordReset(email.text);
                      if (mounted && auth.errorMessage == null) {
                        setState(() => codeRequested = true);
                      }
                    } else {
                      await auth.completePasswordReset(
                        code.text,
                        password.text,
                      );
                    }
                  },
            child: Text(codeRequested ? 'Set new password' : 'Send reset code'),
          ),
        ],
      ),
    );
  }
}
