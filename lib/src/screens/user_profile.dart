import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/user_profile_delete_succesful.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/src/services/auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  String email = '';
  String? username = '';
  String? newUsername;
  String errorMessage = '';

  final TextEditingController _controllerNewUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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
        email = user.email!;
      }
    });

    username = await UserData().getUserDataFromFirebase();
    setState(() {});
  }

  void updateUserDetails(String newDisplayName, String newUsername) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        bool isUsernameAvailableAuth = await UserData().isDisplayNameAvailable(newDisplayName);
        bool isUsernameAvailableField = await UserData().isUsernameNameAvailable(newUsername);

        if (!isUsernameAvailableAuth || !isUsernameAvailableField) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Username is already taken. Please choose a different username.'),
          ));
          return;
        }
        await UserData().updateDisplayName(newDisplayName);
        await UserData().updateUsernameField(user!.uid, newUsername);
        setState(() {
          username = newUsername;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Username updated successfully'),
        ));
        _controllerNewUsername.clear();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update username. Please try again later.'),
        ));
        print('Error updating user details: $e');
      }
    }
  }

  void showLoginScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  Future<void> signOut() async {
    await Auth().signOutUserAccount();
    print('User is logged out: ${user!.uid}');

    showLoginScreen();
  }

  @override
  void dispose() {
    _controllerNewUsername.dispose();
    super.dispose();
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
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.of(context).pop(newUsername);
        //     }),
      ),
      body: Container(
        // height: double.infinity,
        constraints: BoxConstraints(maxWidth: 400),
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
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                // border: Border.all(
                                //   color: Colors.white,
                                //   width: 1,
                                // ),
                              ),
                              child: Container(
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
                                  backgroundColor: const Color.fromARGB(255, 34, 104, 36),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ])
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    ),
                                    child: Container(
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

                            Text('Username: ', style: const TextStyle(fontSize: 14)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(username != null ? '$username' : '', style: const TextStyle(fontSize: 24)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Change username",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          // content: Text("Enter new username"),
                                          actions: [
                                            Form(
                                              key: _formKey,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller: _controllerNewUsername,
                                                    autofocus: false,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                    decoration: InputDecoration(
                                                      errorStyle: const TextStyle(color: Colors.red, fontSize: 14.0),
                                                      border: UnderlineInputBorder(),
                                                      contentPadding: EdgeInsets.zero,
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.greenAccent),
                                                      ),
                                                      errorBorder: UnderlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
                                                      ),
                                                    ),
                                                    // initialValue:
                                                    //     "",

                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter a username';
                                                      }

                                                      return null;
                                                    },
                                                    onSaved: (value) async {
                                                      newUsername = value;
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      updateUserDetails(
                                                          _controllerNewUsername.text, _controllerNewUsername.text);
                                                    },
                                                    child: Text('Update'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Text('Email: ', style: const TextStyle(fontSize: 14)),
                            Text(user?.email != null ? '${user?.email}' : 'No data',
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
                                Text('Change password ', style: const TextStyle(fontSize: 18)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Change password",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          content: Text(
                                              'You will receive a message containing a link to reset your password to the e-mail address provided during registration. Do you agree?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await UserData().sendPasswordResetEmail(email);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
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
                                Text('Delete profile', style: const TextStyle(fontSize: 18)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Delete profile",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          content: Text(
                                              'Deleting your profile will remove all of your information. Once deleted it cannot be recovered.'),
                                          actions: [
                                            Form(
                                              key: _formKey,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              child: Column(
                                                children: [
                                                  Text('Enter password to confirm deletion.'),
                                                  TextFormField(
                                                    controller: _controllerPassword,
                                                    autofocus: false,
                                                    obscureText: true,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                    decoration: InputDecoration(
                                                      errorStyle: const TextStyle(color: Colors.red, fontSize: 14.0),
                                                      border: UnderlineInputBorder(),
                                                      contentPadding: EdgeInsets.zero,
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.greenAccent),
                                                      ),
                                                      errorBorder: UnderlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
                                                      ),
                                                    ),
                                                    // initialValue: "",
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter your password';
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(height: 15),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text(
                                                          'Keep profile',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          if (_formKey.currentState!.validate()) {
                                                            try {
                                                              var user = FirebaseAuth.instance.currentUser;
                                                              var email = user!.email;
                                                              var credential = EmailAuthProvider.credential(
                                                                  email: email!, password: _controllerPassword.text);
                                                              await user.reauthenticateWithCredential(credential);
                                                              await UserData().deleteUserAndData(
                                                                  user.uid, user.email, _controllerPassword.text);
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      SuccessfulDelete(deletedUser: user.email)));
                                                            } catch (e) {
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                content: Text('Incorrect password. Please try again.'),
                                                              ));
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Delete now',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
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
