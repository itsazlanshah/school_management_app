class User {
  const User({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }
}
