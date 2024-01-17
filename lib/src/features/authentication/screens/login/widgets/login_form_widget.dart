import 'package:bet_app/src/features/authentication/screens/login/widgets/forget_password.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  void showHomeScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomeScreen(),
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

  Future<String?> signInUser() async {
    if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
      setState(() {
        errorMessage = "Wszystkie pola muszą być uzupełnione.";
      });
      return errorMessage;
    }

    try {
      User? user = await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      if (user != null) {
        print('User is logged in: ${user.uid}');
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => HomeScreen(),
        // ));
        showHomeScreen();
        return null; // Sign-in successful
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Podany e-mail jest nieprawidłowy.";
          break;
        // case "user-not-found":
        //   print('FirebaseAuthException: ${e.message}, code: ${e.code}');
        //   errorMessage = "Nie znaleziono użytkownika o podanym adresie e-mail.";
        //   break;
        case "wrong-password":
          print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Hasło jest nieprawidłowe.";
          break;
        case "invalid-credential":
          print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Nieprawidłowy e-mail lub hasło.";
          break;
        default:
          print(e.code);
          errorMessage =
              "Logowanie nie powiodło się. Proszę spróbować ponownie.";
          break;
      }
      setState(() {
        errorMessage = errorMessage;
      });
      return errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _entryField('E-mail', _controllerEmail, Icons.email, false),
        const SizedBox(height: 20),
        _entryField('Hasło', _controllerPassword, Icons.password, true),
        const SizedBox(height: 10),
        _errorMessage(),
        ForgetPassword(),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              signInUser();
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color.fromARGB(255, 40, 122, 43),
            ),
            child: const Text(
              "Zaloguj",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
