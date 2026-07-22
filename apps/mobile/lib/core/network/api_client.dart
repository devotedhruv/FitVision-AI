import 'package:dio/dio.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  ApiClient(AppConfig config)
    : _dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl.toString(),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
          headers: const {'Accept': 'application/json'},
        ),
      );

  final Dio _dio;

  Future<Map<String, dynamic>> getJson(String path) async {
    try {
      final response = await _dio.get<Object?>(path);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AppException(ServerFailure());
      }
      return data;
    } on AppException {
      rethrow;
    } on DioException catch (error) {
      throw AppException(_mapDioFailure(error), cause: error.type);
    } catch (error) {
      throw AppException(const UnknownFailure(), cause: error.runtimeType);
    }
  }

  Failure _mapDioFailure(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const TimeoutFailure(),
      DioExceptionType.connectionError => const NetworkFailure(),
      DioExceptionType.badResponse => const ServerFailure(),
      _ => const UnknownFailure(),
    };
  }
}

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(appConfigProvider)),
);
