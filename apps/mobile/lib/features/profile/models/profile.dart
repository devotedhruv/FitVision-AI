class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.preferredUnits,
    this.isCached = false,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;
  final String preferredUnits;
  final bool isCached;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    displayName: json['display_name'] as String,
    avatarUrl: json['avatar_url'] as String?,
    preferredUnits: json['preferred_units'] as String,
    isCached: json['is_cached'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': displayName,
    'avatar_url': avatarUrl,
    'preferred_units': preferredUnits,
  };

  UserProfile asCached() => UserProfile(
    id: id,
    displayName: displayName,
    avatarUrl: avatarUrl,
    preferredUnits: preferredUnits,
    isCached: true,
  );
}
