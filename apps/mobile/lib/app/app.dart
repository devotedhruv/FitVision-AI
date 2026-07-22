import 'package:fitvision_ai/app/router.dart';
import 'package:fitvision_ai/app/theme.dart';
import 'package:flutter/material.dart';

class FitVisionApp extends StatelessWidget {
  const FitVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitVision AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
