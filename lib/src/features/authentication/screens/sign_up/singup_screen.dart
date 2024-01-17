import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/continue_as_guest.dart';
import 'package:bet_app/src/features/authentication/screens/sign_up/successful_registration.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  // final VoidCallback? showHomeScreen;
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String errorMessage = '';

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

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
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
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

  Future<String?> createUserAndCheckEmail(String email, String password) async {
    await Future.delayed(Duration.zero);
    if (_controllerEmail.text.isEmpty ||
        _controllerPassword.text.isEmpty ||
        _controllerName.text.isEmpty ||
        _controllerConfirmPassword.text.isEmpty) {
      setState(() {
        errorMessage = "Wszystkie pola muszą być uzupełnione.";
      });
      return errorMessage;
    }

    if (_controllerPassword.text != _controllerConfirmPassword.text) {
      setState(() {
        errorMessage = "Podane hasła nie są identyczne.";
      });
      return errorMessage;
    }

    try {
      // List<String> signInMethods =
      //     await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // if (signInMethods.isNotEmpty) {
      //   print(
      //       'Użytkownik o podanym adresie email już istnieje: $signInMethods');
      // } else {
      //   print('Email nie jest powiązany z innym kontem.');
      // }

      await Auth().createUserWithEmailAndPassword(
        email: email,
        password: password,
        confirmPassword: _controllerConfirmPassword.text,
        displayName: _controllerName.text,
      );
      showSuccesfulScreen();
      // return null;
    } on FirebaseAuthException catch (e) {
      // print('Error: $e');
      switch (e.code) {
        case "invalid-email":
          // print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Podany e-mail jest nieprawidłowy.";
          break;
        case "email-already-in-use":
          // print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Konto o podanych adresie email już istnieje.";
          break;
        case "weak-password":
          // print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Hasło powinno mieć co najmniej 6 znaków";
          break;
        default:
          print('ze switch default: $e.code');
          errorMessage =
              "Rejestracja nie powiodła się. Proszę spróbować ponownie.";
          break;
      }
      setState(() {
        errorMessage = errorMessage;
      });
    }
    return errorMessage;
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
                child: ElevatedButton(
                  onPressed: () async {
                    await createUserAndCheckEmail(
                      _controllerEmail.text,
                      _controllerPassword.text,
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
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                  ),
                  child: const Text(
                    "Zarejestruj",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Masz już konto?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
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
