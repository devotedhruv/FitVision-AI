export 'app_loading_indicator.dart' show AppLoadingIndicator;

import 'package:fitvision_ai/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.label = 'Loading…'});
  final String label;

  @override
  Widget build(BuildContext context) => AppLoadingIndicator(label: label);
}
