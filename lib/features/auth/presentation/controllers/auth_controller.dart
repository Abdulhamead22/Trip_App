import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_application_1/features/auth/domain/entities/app_user.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/change_password.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/update_profile.dart';

class AuthController extends GetxController {
  final SignUp signUpUseCase;
  final Login loginUseCase;
  final Logout logoutUseCase;
  final ForgotPassword forgotPasswordUseCase;
  final ChangePassword changePasswordUseCase;
  final UpdateProfile updateProfileUseCase;
  final AuthRepository authRepository;

  AuthController({
    required this.signUpUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.forgotPasswordUseCase,
    required this.changePasswordUseCase,
    required this.updateProfileUseCase,
    required this.authRepository,
  });

  final Rxn<AppUser> _user = Rxn<AppUser>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  AppUser? get user => _user.value;

  StreamSubscription<AppUser?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();

    _user.value = authRepository.currentUser;

    _authSubscription = authRepository.authStateChanges().listen((user) {
      _user.value = user;
    });
  }

  void _setLoading(bool value) {
    isLoading.value = value;
    errorMessage.value = '';
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      _user.value = await signUpUseCase(
        name: name,
        email: email,
        password: password,
      );

      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      _user.value = await loginUseCase(
        email: email,
        password: password,
      );

      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> logout() async {
    _setLoading(true);

    try {
      await logoutUseCase();
      _user.value = null;
      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendPasswordResetEmail({
    required String email,
  }) async {
    _setLoading(true);

    try {
      await forgotPasswordUseCase(email: email);
      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);

    try {
      await changePasswordUseCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String name,
  }) async {
    _setLoading(true);

    try {
      _user.value = await updateProfileUseCase(name: name);
      return true;
    } catch (error) {
      errorMessage.value = _getErrorMessage(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('email-already-in-use')) {
      return 'This email is already registered.';
    }

    if (message.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    }

    if (message.contains('weak-password')) {
      return 'Password must be stronger.';
    }

    if (message.contains('user-not-found') ||
        message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return 'Email or password is incorrect.';
    }

    if (message.contains('requires-recent-login')) {
      return 'Please log in again before changing your password.';
    }

    return 'Something went wrong. Please try again.';
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
