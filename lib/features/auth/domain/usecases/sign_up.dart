import 'package:flutter_application_1/features/auth/domain/entities/app_user.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<AppUser> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}
