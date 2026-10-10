
import 'package:flutter_application_1/features/auth/domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  // factory UserModel.fromFirebaseUser({
  //   required String id,
  //   required String? name,
  //   required String? email,
  // }) {
  //   return UserModel(
  //     id: id,
  //     name: name ?? '',
  //     email: email ?? '',
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}