import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

/// Renders only the social connections enabled for this Clerk instance.
/// The provider configuration remains in Clerk; this widget never invents or
/// enables a provider locally.
class SocialAuthButtons extends StatefulWidget {
  const SocialAuthButtons({super.key});

  @override
  State<SocialAuthButtons> createState() => _SocialAuthButtonsState();
}

class _SocialAuthButtonsState extends State<SocialAuthButtons> {
  clerk.Strategy? _activeStrategy;

  @override
  Widget build(BuildContext context) {
    // Authentication widget tests and the Supabase fallback build do not have
    // a ClerkAuth ancestor. In that mode social sign-in is intentionally not
    // rendered; email/password auth remains available.
    try {
      ClerkAuth.of(context, listen: false);
    } catch (_) {
      return const SizedBox.shrink();
    }
    return ClerkAuthBuilder(
      signedOutBuilder: (context, auth) {
        final connections = auth.env.socialConnections.where(
          (connection) => const {
            'google',
            'facebook',
          }.contains(connection.strategy.provider),
        );
        if (connections.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or continue with'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 12),
            ...connections.map(
              (connection) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _activeStrategy == null
                        ? () => _start(context, auth, connection.strategy)
                        : null,
                    icon: connection.logoUrl.isEmpty
                        ? Icon(_iconFor(connection.strategy.provider))
                        : Image.network(
                            connection.logoUrl,
                            width: 20,
                            height: 20,
                            errorBuilder: (_, _, _) =>
                                Icon(_iconFor(connection.strategy.provider)),
                          ),
                    label: Text('Continue with ${_labelFor(connection)}'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _start(
    BuildContext context,
    ClerkAuthState auth,
    clerk.Strategy strategy,
  ) async {
    setState(() => _activeStrategy = strategy);
    try {
      await auth.ssoSignIn(context, strategy);
    } finally {
      if (mounted) setState(() => _activeStrategy = null);
    }
  }

  String _labelFor(clerk.SocialConnection connection) {
    switch (connection.strategy.provider) {
      case 'google':
        return 'Google';
      case 'facebook':
        return 'Facebook';
      case 'x':
        return 'X';
      default:
        return connection.name;
    }
  }

  IconData _iconFor(String? provider) => switch (provider) {
    'google' => Icons.g_mobiledata,
    'facebook' => Icons.facebook,
    'x' => Icons.close,
    _ => Icons.account_circle_outlined,
  };
}
