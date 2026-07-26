import 'package:fitvision_ai/core/network/api_client.dart';

class RemoteWorkoutResult {
  const RemoteWorkoutResult({required this.remoteId});
  final String remoteId;
}

abstract interface class WorkoutRemoteDataSource {
  Future<RemoteWorkoutResult> createOrGet(Map<String, Object?> payload);
}

class ApiWorkoutRemoteDataSource implements WorkoutRemoteDataSource {
  const ApiWorkoutRemoteDataSource(this.client);
  final ApiClient client;
  @override
  Future<RemoteWorkoutResult> createOrGet(Map<String, Object?> payload) async {
    final response = await client.postJson('/api/v1/workouts', payload);
    final id = response['id'] as String?;
    if (id == null || id.isEmpty) {
      throw const FormatException('Workout response did not include an id.');
    }
    return RemoteWorkoutResult(remoteId: id);
  }
}
