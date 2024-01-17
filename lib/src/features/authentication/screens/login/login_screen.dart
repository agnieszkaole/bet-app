import 'package:bet_app/src/features/authentication/screens/login/widgets/continue_as_guest.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/login_form_widget.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/login_header_widget.dart';
import 'package:bet_app/src/features/authentication/screens/sign_up/singup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const LoginHeader(),
                LoginForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Nie masz jeszcze konta? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ));
                      },
                      child: const Text(
                        "Zarejestruj się",
                        style:
                            TextStyle(color: Color.fromARGB(255, 58, 158, 61)),
                      ),
                    ),
                  ],
                ),
                const Center(child: Text("Lub")),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(255, 228, 228, 228),
                    border: Border.all(
                      color: const Color.fromARGB(255, 40, 122, 43),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 18),
                        Text(
                          "Zaloguj się poprzez Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 40, 122, 43),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const ContinueAsGuestScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
