import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/src/services/auth.dart';

class UserProfileEdithScreen extends StatefulWidget {
  const UserProfileEdithScreen({super.key});

  @override
  State<UserProfileEdithScreen> createState() => _UserProfileEdithScreenState();
}

class _UserProfileEdithScreenState extends State<UserProfileEdithScreen> {
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  String? email = '';
  String? username = '';

  String errorMessage = '';

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    initUserDetails();
  }

  Future<void> initUserDetails() async {
    setState(() {
      User? user = Auth().currentUser;
      if (user != null) {
        isAnonymous = user.isAnonymous;
        email = user.email;
      }
    });
    username = await UserData().getUsernameFromFirebase();
    setState(() {});
  }

  void showLoginScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  Future<void> signOut() async {
    await Auth().signOutUserAccount();
    print('User is logged out: ${user!.uid}');

    // setState(() {
    //   user = null;
    // });
    showLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              children: [
                isAnonymous
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 117, 117, 117),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                // border: Border.all(
                                //   color: Colors.white,
                                //   width: 1,
                                // ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 60,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Not logged in',
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'In this mode you only have access to certain functions. ',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Log in to fully use the application.',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 25),
                              width: 200,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                                  signOut();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor:
                                      const Color.fromARGB(255, 34, 104, 36),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ])
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 117, 117, 117),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('Username: ',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: _controllerName,
                              decoration: InputDecoration(
                                // labelText: 'Enter username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                                fillColor:
                                    const Color.fromARGB(255, 48, 85, 50),
                                filled: true,
                              ),
                            ),

                            const SizedBox(height: 20),
                            Text('Email: ',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: _controllerEmail,
                              decoration: InputDecoration(
                                // labelText: 'Enter username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                                fillColor:
                                    const Color.fromARGB(255, 48, 85, 50),
                                filled: true,
                              ),
                            ),
                            // const SizedBox(height: 50),
                            const Divider(
                              height: 100,
                              color: Color.fromARGB(255, 40, 122, 43),
                              thickness: 1.5,
                              // indent: 5,
                              // endIndent: 5,
                            ),
                            const Text(
                              'Change username',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Change password',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Delete profile',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      )
                // :
              ],
            ),
          ],
        ),
      ),
    );
  }
}
