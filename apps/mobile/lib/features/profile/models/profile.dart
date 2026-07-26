class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.preferredUnits,
    this.dateOfBirth,
    this.gender,
    this.country,
    this.timezone,
    this.preferredLanguage,
    this.heightCm,
    this.weightKg,
    this.targetWeightKg,
    this.fitnessLevel,
    this.fitnessGoal,
    this.activityLevel,
    this.movementLimitations,
    this.medicalNoticeAcknowledged = false,
    this.isCached = false,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;
  final String preferredUnits;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? country;
  final String? timezone;
  final String? preferredLanguage;
  final double? heightCm;
  final double? weightKg;
  final double? targetWeightKg;
  final String? fitnessLevel;
  final String? fitnessGoal;
  final String? activityLevel;
  final String? movementLimitations;
  final bool medicalNoticeAcknowledged;
  final bool isCached;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    displayName: json['display_name'] as String,
    avatarUrl: json['avatar_url'] as String?,
    preferredUnits: json['preferred_units'] as String,
    dateOfBirth: DateTime.tryParse(json['date_of_birth'] as String? ?? ''),
    gender: json['gender'] as String?,
    country: json['country'] as String?,
    timezone: json['timezone'] as String?,
    preferredLanguage: json['preferred_language'] as String?,
    heightCm: (json['height_cm'] as num?)?.toDouble(),
    weightKg: (json['weight_kg'] as num?)?.toDouble(),
    targetWeightKg: (json['target_weight_kg'] as num?)?.toDouble(),
    fitnessLevel: json['fitness_level'] as String?,
    fitnessGoal: json['fitness_goal'] as String?,
    activityLevel: json['activity_level'] as String?,
    movementLimitations: json['movement_limitations'] as String?,
    medicalNoticeAcknowledged:
        json['medical_notice_acknowledged'] as bool? ?? false,
    isCached: json['is_cached'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': displayName,
    'avatar_url': avatarUrl,
    'preferred_units': preferredUnits,
    'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
    'gender': gender,
    'country': country,
    'timezone': timezone,
    'preferred_language': preferredLanguage,
    'height_cm': heightCm,
    'weight_kg': weightKg,
    'target_weight_kg': targetWeightKg,
    'fitness_level': fitnessLevel,
    'fitness_goal': fitnessGoal,
    'activity_level': activityLevel,
    'movement_limitations': movementLimitations,
    'medical_notice_acknowledged': medicalNoticeAcknowledged,
  };

  UserProfile asCached() => UserProfile(
    id: id,
    displayName: displayName,
    avatarUrl: avatarUrl,
    preferredUnits: preferredUnits,
    dateOfBirth: dateOfBirth,
    gender: gender,
    country: country,
    timezone: timezone,
    preferredLanguage: preferredLanguage,
    heightCm: heightCm,
    weightKg: weightKg,
    targetWeightKg: targetWeightKg,
    fitnessLevel: fitnessLevel,
    fitnessGoal: fitnessGoal,
    activityLevel: activityLevel,
    movementLimitations: movementLimitations,
    medicalNoticeAcknowledged: medicalNoticeAcknowledged,
    isCached: true,
  );
}
