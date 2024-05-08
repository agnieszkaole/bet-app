// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';

// typedef ErrorCallback = void Function(String errorMessageAuth);

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User signed in: ${userCredential.user}');
    return userCredential.user;
  }

  Future<User?> signInAnonymously() async {
    // try {
    UserCredential userCredential = await _firebaseAuth.signInAnonymously();
    User? user = userCredential.user!;
    print("Anonymous user created: ${user.uid}");
    return user;
    // } catch (e) {
    // print("Error creating anonymous user: $e");
    // return null;
    // }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> signOutUserAccount() async {
    try {
      // User? user = _firebaseAuth.currentUser;
      // if (user != null && user.isAnonymous) {
      //   await user.delete();
      //   print('Anonymous user deleted successfully.');
      // }
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
