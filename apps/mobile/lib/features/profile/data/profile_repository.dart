import 'dart:convert';

import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/core/network/api_client.dart';
import 'package:fitvision_ai/features/profile/models/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  const ProfileRepository(this.client);
  final ApiClient client;

  Future<UserProfile> getMe() async {
    try {
      final profile = UserProfile.fromJson(
        await client.getJson('/api/v1/users/me'),
      );
      await _cache(profile);
      return profile;
    } on AppException catch (error) {
      if (error.failure is! NetworkFailure &&
          error.failure is! TimeoutFailure &&
          error.failure is! ServerFailure) {
        rethrow;
      }
      final cached = await _readCache();
      if (cached != null) return cached.asCached();
      rethrow;
    }
  }

  Future<UserProfile> update({
    String? displayName,
    String? preferredUnits,
  }) async {
    final profile = UserProfile.fromJson(
      await client.patchJson('/api/v1/users/me', {
        'display_name': ?displayName,
        'preferred_units': ?preferredUnits,
      }),
    );
    await _cache(profile);
    return profile;
  }

  Future<void> _cache(UserProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_cacheKey, jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> _readCache() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_cacheKey);
    if (encoded == null) return null;
    try {
      return UserProfile.fromJson(
        Map<String, dynamic>.from(jsonDecode(encoded) as Map),
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  static const _cacheKey = 'fitvision_profile_cache_v1';
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(apiClientProvider)),
);

final currentProfileProvider = FutureProvider<UserProfile>(
  (ref) => ref.watch(profileRepositoryProvider).getMe(),
);
