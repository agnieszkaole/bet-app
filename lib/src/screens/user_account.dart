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
      print('User is logged out: ${user!.uid}');
      setState(() {
        user = null;
        isLogged = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil użytkownika',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          if (isLogged == true)
            GestureDetector(
              onTap: () {
                signOut();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.logout),
              ),
            ),
        ],
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.email != null
                    ? 'Użytkownik: ${user?.email}'
                    : 'Użytkownik: niezalogowany',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              if (isLogged == false)
                GestureDetector(
                  onTap: () {
                    signOut();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text('Zaloguj'),
                        ),
                        Icon(Icons.login_rounded),
                      ],
                    ),
                  ),
                ),

              // ElevatedButton(
              //   onPressed: isLogged ? signOut : signIn,
              //   child: Text(isLogged ? 'Wyloguj' : 'Zaloguj'),
              // )
              // if (isLogged == false)
              //   ElevatedButton(
              //     onPressed: signIn,
              //     child: const Text('Zaloguj'),
              //   ),
            ],
          )),
    );
  }
}
