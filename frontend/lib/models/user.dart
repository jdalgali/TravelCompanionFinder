class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final Map<String, dynamic> preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'preferences': preferences,
    };
  }

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
        return name;
      case 'email':
        return email;
      case 'profileImage':
        return profileImage;
      case 'preferences':
        return preferences;
      default:
        throw ArgumentError('Invalid property name: $key');
    }
  }
}
