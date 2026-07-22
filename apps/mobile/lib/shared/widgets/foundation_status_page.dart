import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/network/api_result.dart';
import 'package:fitvision_ai/core/network/health_service.dart';
import 'package:fitvision_ai/shared/models/health_status.dart';
import 'package:fitvision_ai/shared/widgets/app_error_view.dart';
import 'package:fitvision_ai/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoundationStatusPage extends ConsumerStatefulWidget {
  const FoundationStatusPage({super.key});

  @override
  ConsumerState<FoundationStatusPage> createState() =>
      _FoundationStatusPageState();
}

class _FoundationStatusPageState extends ConsumerState<FoundationStatusPage> {
  ApiResult<HealthStatus>? _result;
  bool _isLoading = false;

  Future<void> _checkBackend() async {
    setState(() => _isLoading = true);
    final result = await ref.read(healthServiceProvider).check();
    if (!mounted) return;
    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('FitVision AI')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Phase 1 Foundation',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Technical validation screen for configuration and API connectivity.',
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatusRow(
                            label: 'Environment',
                            value: config.environment.name,
                          ),
                          const SizedBox(height: 12),
                          _StatusRow(
                            label: 'API base URL',
                            value: config.apiBaseUrl.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _checkBackend,
                    icon: const Icon(Icons.cloud_done_outlined),
                    label: const Text('Check Backend Connection'),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const AppLoadingIndicator()
                  else if (_result case ApiSuccess<HealthStatus>(:final value))
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Backend connected — ${value.service} ${value.version} (${value.environment})',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (_result case ApiError<HealthStatus>(:final failure))
                    AppErrorView(
                      message: failure.message,
                      actionLabel: 'Retry',
                      onRetry: _checkBackend,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        SelectableText(value),
      ],
    );
  }
}
