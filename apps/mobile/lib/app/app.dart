import 'package:fitvision_ai/app/router.dart';
import 'package:fitvision_ai/app/theme.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FitVisionApp extends ConsumerStatefulWidget {
  const FitVisionApp({super.key});

  @override
  ConsumerState<FitVisionApp> createState() => _FitVisionAppState();
}

class _FitVisionAppState extends ConsumerState<FitVisionApp> {
  late final AuthViewModel auth;

  @override
  void initState() {
    super.initState();
    auth = ref.read(authViewModelProvider);
    activeAuthViewModel = auth;
    auth.addListener(appRouter.refresh);
  }

  @override
  void dispose() {
    auth.removeListener(appRouter.refresh);
    if (identical(activeAuthViewModel, auth)) activeAuthViewModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'FitVision AI',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    routerConfig: appRouter,
  );
}
