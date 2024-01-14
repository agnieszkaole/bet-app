import 'package:bet_app/main.dart';
import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/src/services/auth.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  String email = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      isAnonymous = user!.isAnonymous;
      // email = user!.email;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchUserData();
  // }

  // Future _fetchUserData() async {
  //   Map<String, dynamic> userData = await Auth.checkUserStatus();
  //   bool? isAnonymous = userData['isAnonymous'];
  //   String? userEmail = userData['email'];
  //   return userData;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   user = Auth().currentUser;
  //   Auth.checkUserStatus().then((result) {
  //     setState(() {
  //       isAnonymous = result;
  //     });
  //   });
  // }

  Future<void> signOut() async {
    try {
      await Auth().signOut();
      print('User is logged out: ${user!.uid}');
      setState(() {
        user = null;
        // isLogged = false;
      });
    } catch (e) {
      print('Error signing out: $e');
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  void signIn() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          if (!isAnonymous)
            GestureDetector(
              onTap: () {
                signOut();
              },
              child: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Wyloguj',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(Icons.logout),
                    ],
                  )),
            )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                // isLogged
                // ?

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
                              'Gość ',
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'W tym trybie masz dostęp jedynie do niektórych funkcji. Zaloguj się, żeby móc w\u{00A0}pełni korzystać z\u{00A0}aplikacji.',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 25),
                              width: 200,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor:
                                      const Color.fromARGB(255, 40, 122, 43),
                                ),
                                child: const Text(
                                  "Zaloguj",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            user?.email != null
                                ? 'Nazwa użytkownika: dummy data'
                                : 'Brak danych',
                          ),
                          const SizedBox(height: 20),
                          Text(
                            user?.email != null
                                ? 'Email: ${user?.email}'
                                : 'Brak danych',
                          ),
                          const SizedBox(height: 50),
                          // Text(
                          //   'Zmień nazwę użytkownika',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                          // Text(
                          //   'Zmień hasło',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                          // Text(
                          //   'Usuń konto',
                          //   style: const TextStyle(fontSize: 16),
                          // ),
                        ],
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
