import 'package:dio/dio.dart';
import 'package:fitvision_ai/core/config/app_config.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  ApiClient(
    AppConfig config, {
    String? Function()? accessTokenProvider,
    Dio? dio,
  }) : _accessTokenProvider = accessTokenProvider ?? (() => null),
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: config.apiBaseUrl.toString(),
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 10),
               responseType: ResponseType.json,
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _accessTokenProvider();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final String? Function() _accessTokenProvider;

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

  Future<List<Map<String, dynamic>>> getJsonList(String path) async {
    try {
      final response = await _dio.get<Object?>(path);
      final data = response.data;
      if (data is! List) throw const AppException(ServerFailure());
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } on AppException {
      rethrow;
    } on DioException catch (error) {
      throw AppException(_mapDioFailure(error), cause: error.type);
    }
  }

  Future<Map<String, dynamic>> patchJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.patch<Object?>(path, data: body);
      return Map<String, dynamic>.from(response.data! as Map);
    } on DioException catch (error) {
      throw AppException(_mapDioFailure(error), cause: error.type);
    }
  }

  Failure _mapDioFailure(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const TimeoutFailure(),
      DioExceptionType.connectionError => const NetworkFailure(),
      DioExceptionType.badResponse when error.response?.statusCode == 401 =>
        const UnauthorizedFailure(),
      DioExceptionType.badResponse => const ServerFailure(),
      _ => const UnknownFailure(),
    };
  }
}

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    ref.watch(appConfigProvider),
    accessTokenProvider: () =>
        ref.read(authRepositoryProvider).currentAccessToken,
  ),
);
