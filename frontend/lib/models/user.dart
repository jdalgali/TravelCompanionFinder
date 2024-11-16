class User {
  final String id;
  final String email;
  final String name;
  Map<String, dynamic>? preferences;
  String? profileImage;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.preferences,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      preferences: json['preferences'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'preferences': preferences,
      'profileImage': profileImage,
    };
  }
}
