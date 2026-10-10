import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource({
    required this.firebaseAuth,
    required this.firestore,
  });

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges();
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedName = name.trim();

    late UserCredential credential;

    credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: trimmedEmail,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Account creation failed.');
    }

    await user.updateDisplayName(trimmedName);

    await firestore.collection('users').doc(user.uid).set({
      'name': trimmedName,
      'email': trimmedEmail,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signInAnonymously() {
    return firebaseAuth.signInAnonymously();
  }

  Future<void> logout() {
    return firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return firebaseAuth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null || user.email == null) {
      throw Exception('No authenticated user.');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> updateProfile({
    required String name,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    final updatedName = name.trim();

    await user.updateDisplayName(updatedName);

    await firestore.collection('users').doc(user.uid).set({
      'name': updatedName,
      'email': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
