import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
