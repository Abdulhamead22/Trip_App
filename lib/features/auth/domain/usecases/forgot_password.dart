import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  Future<void> call({
    required String email,
  }) {
    return repository.sendPasswordResetEmail(
      email: email,
    );
  }
}
