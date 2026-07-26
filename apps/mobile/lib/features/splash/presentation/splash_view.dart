import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.accessibility_new, size: 72),
            SizedBox(height: 16),
            Text('FitVision AI', style: TextStyle(fontSize: 28)),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    ),
  );
}
