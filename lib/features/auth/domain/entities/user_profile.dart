/// The signed-in user.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    this.phone = '',
  });

  final String name;
  final String email;
  final String phone;

  /// First name for the home-screen greeting.
  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  UserProfile copyWith({String? name, String? email, String? phone}) =>
      UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
      };
}
