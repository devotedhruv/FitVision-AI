class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.preferredUnits,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;
  final String preferredUnits;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    displayName: json['display_name'] as String,
    avatarUrl: json['avatar_url'] as String?,
    preferredUnits: json['preferred_units'] as String,
  );
}
