import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/features/authentication/data/clerk_auth_repository.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClerkAuthScope extends StatefulWidget {
  const ClerkAuthScope({required this.config, required this.child, super.key});
  final AppConfig config;
  final Widget child;

  @override
  State<ClerkAuthScope> createState() => _ClerkAuthScopeState();
}

class _ClerkAuthScopeState extends State<ClerkAuthScope> {
  ClerkAuthRepository? _repository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository ??= ClerkAuthRepository(ClerkAuth.of(context, listen: false));
  }

  @override
  void dispose() {
    _repository?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(widget.config),
      authRepositoryProvider.overrideWithValue(_repository!),
    ],
    child: widget.child,
  );
}
