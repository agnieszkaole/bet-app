import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/screens/user_profile_edith.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/src/services/auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
    // var predictedMatchProvider = Provider.of<PredictedMatchProvider>(context);
    // if (predictedMatchProvider.predictedMatchList.isNotEmpty) {
    //   predictedMatchProvider.predictedMatchList.clear();
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        // height: double.infinity,
        width: MediaQuery.of(context).size.width,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    user?.displayName != null
                                        ? '${user?.displayName}'
                                        : 'No data',
                                    style: const TextStyle(fontSize: 24)),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.edit_sharp,
                                        size: 30,
                                        // color: Color.fromARGB(255, 40, 122, 43),
                                      ),
                                      SizedBox(width: 5),
                                      // Padding(
                                      //   padding: EdgeInsets.only(right: 10),
                                      //   child: Text(
                                      //     'Edith',
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 50,
                              color: Color.fromARGB(255, 40, 122, 43),
                              thickness: 1.5,
                              // indent: 5,
                              // endIndent: 5,
                            ),
                            Text('Email: ',
                                style: const TextStyle(fontSize: 14)),
                            Text(
                                user?.email != null
                                    ? '${user?.email}'
                                    : 'No data',
                                style: const TextStyle(fontSize: 24)),
                            // const SizedBox(height: 50),
                            const Divider(
                              height: 50,
                              color: Color.fromARGB(255, 40, 122, 43),
                              thickness: 1.5,
                              // indent: 5,
                              // endIndent: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Change password ',
                                    style: const TextStyle(fontSize: 18)),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.password_rounded,
                                        size: 30,
                                        // color: Color.fromARGB(255, 40, 122, 43),
                                      ),
                                      SizedBox(width: 5),
                                      // Padding(
                                      //   padding: EdgeInsets.only(right: 10),
                                      //   child: Text(
                                      //     'Edith',
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delete profile',
                                    style: const TextStyle(fontSize: 18)),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.delete_forever_rounded,
                                        size: 30,
                                        // color: Color.fromARGB(255, 40, 122, 43),
                                      ),
                                      SizedBox(width: 5),
                                      // Padding(
                                      //   padding: EdgeInsets.only(right: 10),
                                      //   child: Text(
                                      //     'Delete',
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
