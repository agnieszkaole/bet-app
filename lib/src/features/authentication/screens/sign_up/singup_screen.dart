import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/continue_as_guest.dart';
import 'package:bet_app/src/features/authentication/screens/sign_up/successful_registration.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

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
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
        fillColor: Color.fromARGB(255, 48, 85, 50),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
    );
  }

  Future<void> checkAndCreateUser({
    required String displayName,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
    // required ErrorCallback errorCallback,
  }) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        // errorCallback('Email is already in use. Please use a different email.');
        return;
      }

      // Email is not in use, proceed with user creation
      UserCredential userCredential =
          await Auth().createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        confirmPassword: confirmPassword,
        context: context,
        // errorCallback: (errorMessageAuth) {
        //   setState(() {
        //     errorMessage = errorMessageAuth;
        //   });
        // },
      );

      User? user = userCredential.user;

      if (user != null) {
        // User created successfully, do additional tasks if needed
        print('User is logged in: ${user.uid}');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      // errorCallback(errorMessage);
    }
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : errorMessage,
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () async {
          await checkAndCreateUser(
            email: _controllerEmail.text,
            password: _controllerPassword.text,
            confirmPassword: _controllerConfirmPassword.text,
            displayName: _controllerName.text,
            context: context,
            // errorCallback: (errorMessageAuth) {
            // setState(() {
            // errorMessage = errorMessageAuth;
            // });
            // },
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color.fromARGB(255, 40, 122, 43),
        ),
        child: const Text(
          "Zarejestruj",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    "Zarejestruj się",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Stwórz swoje konto",
                    style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  _entryField('nazwa użytkownika', _controllerName,
                      Icons.person, false),
                  const SizedBox(height: 20),
                  _entryField('e-mail', _controllerEmail, Icons.email, false),
                  const SizedBox(height: 20),
                  _entryField(
                      'hasło', _controllerPassword, Icons.password, true),
                  const SizedBox(height: 20),
                  _entryField('potwierdź hasło', _controllerConfirmPassword,
                      Icons.password, true),
                  const SizedBox(height: 10),
                  _errorMessage(),
                  const SizedBox(height: 20),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: _submitButton()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Masz już konto?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                      child: const Text(
                        "Zaloguj",
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 122, 43),
                        ),
                      )),
                ],
              ),
              const ContinueAsGuestScreen(),
            ],
          ),
        ),
      ),
    ));
  }
}
