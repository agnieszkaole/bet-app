import 'package:bet_app/src/features/authentication/screens/sign_up/successful_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// typedef ErrorCallback = void Function(String errorMessageAuth);

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // try {
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User signed in: ${userCredential.user}');
    return userCredential.user;
    // } catch (e) {
    //   print('Error signing in: $e');
    //   return null;
    // }
  }

  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      User? user = userCredential.user!;
      print("Anonymous user created: ${user.uid}");
      return user;
    } catch (e) {
      print("Error creating anonymous user: $e");
      return null;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
  }) async {
    // try {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(displayName);
    }
    // } catch (e) {
    //   print('Error creating user: $e');
    //   // Handle error, e.g., display an error message to the user
    // }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
