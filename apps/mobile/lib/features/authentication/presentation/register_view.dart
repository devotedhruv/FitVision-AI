import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/authentication/presentation/social_auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});
  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  bool obscurePassword = true;
  String? validationError;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authViewModelProvider);
    final isLoading = auth.status == AuthStatus.loading;
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: fullName,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            decoration: const InputDecoration(labelText: 'Full name'),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('register-email'),
            controller: email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('register-password'),
            controller: password,
            obscureText: obscurePassword,
            autofillHints: const [AutofillHints.newPassword],
            decoration: const InputDecoration(
              labelText: 'Password',
              helperText: 'Use at least 8 characters.',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: confirmation,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              suffixIcon: IconButton(
                tooltip: obscurePassword ? 'Show passwords' : 'Hide passwords',
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),
          if (validationError != null || auth.errorMessage != null)
            Semantics(
              liveRegion: true,
              container: true,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  validationError ?? auth.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          FilledButton(
            key: const Key('register-submit'),
            onPressed: isLoading ? null : () => _submit(auth),
            child: isLoading
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Creating account…'),
                    ],
                  )
                : const Text('Register'),
          ),
          const SizedBox(height: 16),
          const SocialAuthButtons(),
          TextButton(
            onPressed: () => context.go('/auth/login'),
            child: const Text('Already have an account? Sign in'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(AuthViewModel auth) async {
    FocusScope.of(context).unfocus();
    setState(() => validationError = null);
    final name = fullName.text.trim();
    final address = email.text.trim();
    final secret = password.text;
    if (name.isEmpty) {
      setState(() => validationError = 'Enter your full name.');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(address)) {
      setState(() => validationError = 'Enter a valid email address.');
      return;
    }
    if (secret.length < 8) {
      setState(
        () => validationError = 'Password must be at least 8 characters.',
      );
      return;
    }
    if (secret != confirmation.text) {
      setState(() => validationError = 'Passwords do not match.');
      return;
    }
    await auth.registerWithName(name, address, secret);
  }
}
