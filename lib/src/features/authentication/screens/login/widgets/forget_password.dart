import 'package:bet_app/src/constants/app_colors.dart';
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
          barrierColor: Color.fromARGB(167, 9, 11, 29),
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.green), borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: const Text(
                "Forget password",
                style: TextStyle(fontSize: 16),
              ),
              content: const Text(
                  'You will receive a message containing a link to reset your password to the e-mail address. Do you agree?'),
              actions: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.greenDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(width: 1, color: AppColors.greenDark),
                    ),
                    // elevation: 4.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.green),
                  ),
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.greenDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(width: 1, color: AppColors.greenDark),
                    ),
                    // elevation: 4.0,
                  ),
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
        style: TextStyle(color: AppColors.green),
      ),
    );
  }
}
