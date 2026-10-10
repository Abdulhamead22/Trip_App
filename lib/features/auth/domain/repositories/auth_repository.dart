import 'package:flutter_application_1/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<AppUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<AppUser> updateProfile({
    required String name,
  });

  Stream<AppUser?> authStateChanges();
}
