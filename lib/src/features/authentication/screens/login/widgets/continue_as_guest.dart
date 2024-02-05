import 'package:bet_app/src/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/src/services/auth.dart';

class ContinueAsGuestScreen extends StatefulWidget {
  const ContinueAsGuestScreen({super.key});

  @override
  State<ContinueAsGuestScreen> createState() => _ContinueAsGuestScreenState();
}

class _ContinueAsGuestScreenState extends State<ContinueAsGuestScreen> {
  Future<User?> signInUserAnonymous() async {
    try {
      User? user = await Auth().signInAnonymously();
      if (user != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
        foregroundColor: Colors.white,
      ),
      onPressed: () async {
        User? user = await signInUserAnonymous();
        if (user != null) {
          print("User is signed in: ${user.uid}");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
        } else {
          print("Failed to sign in anonymously");
        }
      },
      child: const Text(
        'Continue as a guest',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
