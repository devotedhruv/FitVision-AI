class HealthStatus {
  const HealthStatus({
    required this.status,
    required this.service,
    required this.version,
    required this.environment,
  });

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    String requiredString(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Health response field "$key" is invalid.');
      }
      return value;
    }

    return HealthStatus(
      status: requiredString('status'),
      service: requiredString('service'),
      version: requiredString('version'),
      environment: requiredString('environment'),
    );
  }

  final String status;
  final String service;
  final String version;
  final String environment;
}
