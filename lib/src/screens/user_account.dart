import 'package:bet_app/main.dart';
import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:provider/provider.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  String? email = '';
  String? username = '';

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     isAnonymous = user!.isAnonymous;
  //     email = user!.email;
  //   });
  // }

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
    // var predictedMatchProvider = Provider.of<PredictedMatchProvider>(context);
    // if (predictedMatchProvider.predictedMatchList.isNotEmpty) {
    //   predictedMatchProvider.predictedMatchList.clear();
    // }
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
                        padding: EdgeInsets.only(right: 10),
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
                              'Niezalogowany',
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'W tym trybie masz dostęp jedynie do niektórych funkcji. Zaloguj się, żeby móc w\u{00A0}pełni korzystać z\u{00A0}aplikacji.',
                              style: TextStyle(fontSize: 18),
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
                                      const Color.fromARGB(255, 40, 122, 43),
                                ),
                                child: const Text(
                                  "Zaloguj",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
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
                            'Nazwa użytkownika: ${username}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Text(
                              user?.email != null
                                  ? 'Email: ${user?.email}'
                                  : 'Brak danych',
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 50),
                          const Text(
                            'Zmień nazwę użytkownika',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Zmień hasło',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Usuń konto',
                            style: TextStyle(fontSize: 16),
                          ),
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
