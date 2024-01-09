import 'package:bet_app/main.dart';
import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bet_app/src/services/auth.dart';

class UserAccountScreen extends StatefulWidget {
  UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  User? user = Auth().currentUser;
  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    user = Auth().currentUser;
    isLogged = user != null;
  }

  Future<void> signOut() async {
    try {
      await Auth().signOut();
      setState(() {
        user = null;
        isLogged = false;
      });
      print('User is logged out');
    } catch (e) {
      print('Error signing out: $e');
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }

  void signIn() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }

  // Future<void> checkLoggedIn() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;
  //   setState(() {
  //     isLogged = !isLogged;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Twój profil"),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(user?.email ?? 'Niezalogowyany'),
              ElevatedButton(
                onPressed: isLogged ? signOut : signIn,
                child: Text(isLogged ? 'Wyloguj' : 'Zaloguj'),
              )
            ],
          )),
    );
  }
}
