import 'package:flutter_application_1/features/auth/domain/entities/app_user.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<AppUser> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}
