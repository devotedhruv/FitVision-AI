import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/core/network/api_client.dart';
import 'package:fitvision_ai/core/network/api_result.dart';
import 'package:fitvision_ai/shared/models/health_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthService {
  const HealthService(this._client);
  final ApiClient _client;

  Future<ApiResult<HealthStatus>> check() async {
    try {
      return ApiSuccess(
        HealthStatus.fromJson(await _client.getJson('/api/v1/health')),
      );
    } on AppException catch (error) {
      return ApiError(error.failure);
    } on FormatException {
      return const ApiError(ServerFailure());
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }
}

final healthServiceProvider = Provider<HealthService>(
  (ref) => HealthService(ref.watch(apiClientProvider)),
);
