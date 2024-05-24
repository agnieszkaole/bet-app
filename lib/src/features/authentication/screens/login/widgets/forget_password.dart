import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({super.key, this.email});
  String? email;

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  // User? user = Auth().currentUser;
  // String email = '';

  // @override
  // void initState() {
  // super.initState();
  // initUserDetails();
  // }

  // Future<void> initUserDetails() async {
  //   setState(() {
  //     User? user = Auth().currentUser;
  //     if (user != null) {
  //       email = user.email!;
  //     }
  //   });

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Forget password",
                style: TextStyle(fontSize: 16),
              ),
              content: const Text(
                  'You will receive a message containing a link to reset your password to the e-mail address. Do you agree?'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    // backgroundColor: Color.fromARGB(255, 205, 255, 206),
                    foregroundColor: const Color.fromARGB(255, 6, 165, 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: Color.fromARGB(255, 6, 165, 11)),
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
                      backgroundColor: const Color.fromARGB(255, 2, 126, 6),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () async {
                    await UserData().sendPasswordResetEmail(widget.email!);
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
      style: TextButton.styleFrom(
        alignment: Alignment.topRight,
      ),
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Color.fromARGB(255, 58, 158, 61)),
      ),
    );
  }
}
