import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/continue_as_guest.dart';
import 'package:bet_app/src/features/authentication/screens/register/successful_registration.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  // final VoidCallback? showHomeScreen;
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String errorMessage = '';

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  void showSuccesfulScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SuccessfulRegistration(),
    ));
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    IconData icon,
    bool obscureText,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        fillColor: const Color.fromARGB(255, 48, 85, 50),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : errorMessage,
      // "",
      style: const TextStyle(
        color: Colors.red,
      ),
    );
  }

  // Future<bool> isDisplayNameAvailable(String displayName) async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: displayName).get();

  //     return querySnapshot.docs.isEmpty;
  //   } catch (e) {
  //     print('Error checking display name availability: $e');

  //     return false;
  //   }
  // }

  Future<String?> createUserAndCheckEmail(String email, String password, displayName) async {
    await Future.delayed(Duration.zero);
    if (_controllerEmail.text.isEmpty ||
        _controllerPassword.text.isEmpty ||
        _controllerName.text.isEmpty ||
        _controllerConfirmPassword.text.isEmpty) {
      setState(() {
        errorMessage = "All fields must be completed.";
      });
      return errorMessage;
    }

    if (_controllerPassword.text != _controllerConfirmPassword.text) {
      setState(() {
        errorMessage = "Provide passwords are different.";
      });
      return errorMessage;
    }

    try {
      bool isDisplayNameAvailableFirebase = await UserData().isDisplayNameAvailable(displayName);
      if (isDisplayNameAvailableFirebase) {
        UserCredential userCredential = await Auth().createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await userCredential.user?.updateDisplayName(displayName);
        showSuccesfulScreen();
        addUserDetails(
          _controllerName.text.trim(),
          _controllerEmail.text.trim(),
        );
      } else {
        errorMessage = "The selected username is already taken.";
        print(errorMessage);
      }

      // return null;
    } on FirebaseAuthException catch (e) {
      // print('Error: $e');
      switch (e.code) {
        case "invalid-email":
          // print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Invalid email.";
          break;
        case "email-already-in-use":
          // print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Email is already in use.";
          break;
        case "weak-password":
          // print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Weak password. The password should be at least 6 characters long.";
          break;
        default:
          print('ze switch default: $e.code');
          errorMessage = "Registration failed. Please try again.";
          break;
      }
      setState(() {
        errorMessage = errorMessage;
      });
    }
    return errorMessage;
  }

  Future<void> addUserDetails(String username, String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('Error adding user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        // height: MediaQuery.of(context).size.height - 50,
        // width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      Text(
                        "Betapp",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const Text("Create your account", style: TextStyle(fontSize: 16)),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      _entryField('Username', _controllerName, Icons.person, false),
                      const SizedBox(height: 20),
                      _entryField('Email', _controllerEmail, Icons.email, false),
                      const SizedBox(height: 20),
                      _entryField('Password', _controllerPassword, Icons.password, true),
                      const SizedBox(height: 20),
                      _entryField('Confirm Password', _controllerConfirmPassword, Icons.password, true),
                      const SizedBox(height: 10),
                      _errorMessage(),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: ElevatedButton(
                      onPressed: () async {
                        await createUserAndCheckEmail(
                          _controllerEmail.text,
                          _controllerPassword.text,
                          _controllerName.text,
                        );
                        // await createUserAndCheckEmail(
                        //   _controllerEmail.text,
                        //   _controllerPassword.text,
                        // );
                        // await createUserAndCheckEmail(
                        // email: _controllerEmail.text,
                        // password: _controllerPassword.text,
                        // confirmPassword: _controllerConfirmPassword.text,
                        // displayName: _controllerName.text,
                        // context: context,
                        // errorCallback: (errorMessageAuth) {
                        // setState(() {
                        // errorMessage = errorMessageAuth;
                        // });
                        // },
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              color: Color.fromARGB(255, 40, 122, 43),
                            ),
                          )),
                    ],
                  ),
                  // const ContinueAsGuestScreen(),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
