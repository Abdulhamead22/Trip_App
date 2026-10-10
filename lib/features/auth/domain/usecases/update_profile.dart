import 'package:flutter_application_1/features/auth/domain/entities/app_user.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfile {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  Future<AppUser> call({
    required String name,
  }) {
    return repository.updateProfile(
      name: name,
    );
  }
}
