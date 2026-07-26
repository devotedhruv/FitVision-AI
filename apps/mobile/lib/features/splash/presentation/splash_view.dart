import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFF02050D),
    body: SizedBox.expand(
      child: Image(
        image: AssetImage('assets/images/fitvision_splash.png'),
        fit: BoxFit.cover,
        semanticLabel: 'FitVision AI',
      ),
    ),
  );
}
