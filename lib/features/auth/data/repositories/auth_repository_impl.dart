import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_1/features/auth/data/models/user_model.dart';
import 'package:flutter_application_1/features/auth/domain/entities/app_user.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  AppUser? get currentUser {
    final user = remoteDataSource.currentUser;

    if (user == null) return null;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return remoteDataSource.authStateChanges().map((user) {
      if (user == null) return null;

      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    });
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
    );

    final user = credential.user!;

    return UserModel(
      id: user.uid,
      name: name.trim(),
      email: user.email ?? email.trim(),
    );
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await remoteDataSource.login(
      email: email,
      password: password,
    );

    final user = remoteDataSource.currentUser!;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return remoteDataSource.sendPasswordResetEmail(
      email: email,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<AppUser> updateProfile({
    required String name,
  }) async {
    await remoteDataSource.updateProfile(name: name);

    final user = remoteDataSource.currentUser!;

    return UserModel(
      id: user.uid,
      name: name.trim(),
      email: user.email ?? '',
    );
  }
}
