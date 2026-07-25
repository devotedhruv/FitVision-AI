import 'package:fitvision_ai/core/network/api_client.dart';
import 'package:fitvision_ai/features/profile/models/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileRepository {
  const ProfileRepository(this.client);
  final ApiClient client;

  Future<UserProfile> getMe() async =>
      UserProfile.fromJson(await client.getJson('/api/v1/users/me'));

  Future<UserProfile> update({
    String? displayName,
    String? preferredUnits,
  }) async => UserProfile.fromJson(
    await client.patchJson('/api/v1/users/me', {
      'display_name': ?displayName,
      'preferred_units': ?preferredUnits,
    }),
  );
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(apiClientProvider)),
);

final currentProfileProvider = FutureProvider<UserProfile>(
  (ref) => ref.watch(profileRepositoryProvider).getMe(),
);
