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
  // bool isAnonymous = true;
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
        // isAnonymous = user.isAnonymous;
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
        backgroundColor: Colors.transparent,
        surfaceTintColor: Color.fromARGB(255, 26, 26, 26),
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
      body: Center(
        child: Container(
          height: 500,
          width: MediaQuery.of(context).size.width - 50,
          constraints: BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),

            border: Border.all(width: 0.4, color: Color.fromARGB(99, 206, 206, 206)),
            // color: Color.fromARGB(100, 39, 39, 39),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(120, 50, 124, 15),
                Color.fromARGB(120, 31, 77, 10),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 62, 155, 19),
                                Color.fromARGB(255, 31, 77, 10),
                              ],
                            ),
                            color: Color.fromARGB(255, 0, 146, 0),
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
                        const SizedBox(height: 50),
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
                                backgroundColor: Color.fromARGB(255, 32, 32, 32),
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
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                            contentPadding: EdgeInsets.all(10.0),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: const BorderSide(color: Colors.greenAccent),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
                                            ),
                                            // errorText: accessCodeError,
                                          ),
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
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            updateUserDetails(_controllerNewUsername.text, _controllerNewUsername.text);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            // elevation: 4.0,
                                          ),
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
                  SizedBox(height: 20),
                  Text('Email: ', style: const TextStyle(fontSize: 14)),
                  Text(user?.email != null ? '${user?.email}' : 'No data', style: const TextStyle(fontSize: 24)),
                ],
              ),
              // Divider(
              //   color: Color.fromARGB(255, 26, 112, 0),
              //   thickness: 1.3,
              // ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Row(
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
                                      style: TextButton.styleFrom(
                                        // backgroundColor: Color.fromARGB(255, 205, 255, 206),
                                        foregroundColor: Color.fromARGB(255, 6, 165, 11),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          side: BorderSide(color: Color.fromARGB(255, 6, 165, 11)),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Color.fromARGB(255, 2, 126, 6),
                                          foregroundColor: Color.fromARGB(255, 255, 255, 255)),
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
                                  style: TextStyle(fontSize: 20),
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
                                        SizedBox(height: 10),
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
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                            contentPadding: EdgeInsets.all(10.0),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: const BorderSide(color: Colors.greenAccent),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
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
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Color.fromARGB(255, 255, 1, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25),
                                                  side: BorderSide(color: Color.fromARGB(255, 255, 1, 1)),
                                                ),
                                                // elevation: 4.0,
                                              ),
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
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: Color.fromARGB(255, 2, 126, 6),
                                                  foregroundColor: Color.fromARGB(255, 255, 255, 255)),
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
            ],
          ),
        ),
      ),
    );
  }
}
