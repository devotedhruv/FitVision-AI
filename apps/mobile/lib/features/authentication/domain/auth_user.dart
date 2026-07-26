class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
    this.fullName,
    this.firstName,
    this.username,
    this.avatarUrl,
  });

  final String id;
  final String? email;
  final bool emailVerified;
  final String? fullName;
  final String? firstName;
  final String? username;
  final String? avatarUrl;

  String get resolvedDisplayName {
    for (final candidate in [fullName, firstName, username]) {
      final value = candidate?.trim();
      if (value != null && value.isNotEmpty) return value;
    }
    final address = email?.trim();
    if (address != null && address.contains('@')) {
      return address.substring(0, address.indexOf('@'));
    }
    return 'Athlete';
  }
}
