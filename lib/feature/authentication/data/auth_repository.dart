import 'package:flutter_application_1/feature/authentication/domain/user.dart';

class AuthRepository {
  static final List<User> _users = [
    User(email: 'admin@school.com', password: '123456', name: 'Admin'),
  ];

  Future<User> signIn(String email, String password) async {
    for (final user in _users) {
      if (user.email == email && user.password == password) {
        return user;
      }
    }

    throw Exception('Invalid email or password.');
  }

  Future<bool> signUp(User newUser) async {
    final emailAlreadyExists = _users.any(
      (user) => user.email == newUser.email,
    );
    if (emailAlreadyExists) {
      throw Exception('Email already exists');
    }

    _users.add(newUser);
    return true;
  }
}
