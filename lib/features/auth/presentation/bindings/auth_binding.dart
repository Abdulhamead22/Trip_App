import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/change_password.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/update_profile.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
      ),
    );

    Get.lazyPut(
      () => SignUp(Get.find<AuthRepository>()),
    );

    Get.lazyPut(
      () => Login(Get.find<AuthRepository>()),
    );

    Get.lazyPut(
      () => Logout(Get.find<AuthRepository>()),
    );

    Get.lazyPut(
      () => ForgotPassword(Get.find<AuthRepository>()),
    );

    Get.lazyPut(
      () => ChangePassword(Get.find<AuthRepository>()),
    );

    Get.lazyPut(
      () => UpdateProfile(Get.find<AuthRepository>()),
    );

    Get.put<AuthController>(
      AuthController(
        signUpUseCase: Get.find<SignUp>(),
        loginUseCase: Get.find<Login>(),
        logoutUseCase: Get.find<Logout>(),
        forgotPasswordUseCase: Get.find<ForgotPassword>(),
        changePasswordUseCase: Get.find<ChangePassword>(),
        updateProfileUseCase: Get.find<UpdateProfile>(),
        authRepository: Get.find<AuthRepository>(),
      ),
      permanent: true,
    );
  }
}
