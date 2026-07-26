import 'package:fitvision_ai/core/network/api_client.dart';

class RemoteRunResult {
  const RemoteRunResult(this.remoteId);
  final String remoteId;
}

abstract interface class RunningRemoteDataSource {
  Future<RemoteRunResult> createOrGet(Map<String, Object?> payload);
}

class ApiRunningRemoteDataSource implements RunningRemoteDataSource {
  ApiRunningRemoteDataSource(this.api);
  final ApiClient api;
  @override
  Future<RemoteRunResult> createOrGet(Map<String, Object?> payload) async {
    final json = await api.postJson('/api/v1/runs', payload);
    return RemoteRunResult(json['id'] as String);
  }
}
