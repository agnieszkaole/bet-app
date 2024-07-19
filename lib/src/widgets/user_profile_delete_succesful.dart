import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';

import 'package:flutter/material.dart';

class SuccessfulDelete extends StatefulWidget {
  const SuccessfulDelete({super.key, this.deletedUser});
  final String? deletedUser;

  @override
  State<SuccessfulDelete> createState() => _SuccessfulDeleteState();
}

class _SuccessfulDeleteState extends State<SuccessfulDelete> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Profile ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${widget.deletedUser} ',
                  style: const TextStyle(fontSize: 24),
                ),
                const Text(
                  ' has been deleted',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
