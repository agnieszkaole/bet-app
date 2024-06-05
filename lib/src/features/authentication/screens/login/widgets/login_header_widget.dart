import 'package:bet_app/src/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Text(
        //   "BetSprint",
        //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        // ),
        Text(
          'BETsprint',
          style: TextStyle(
            color: AppColors.green,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat-BoldItalic',
            fontSize: 45,
          ),
        ),
        // SizedBox(height: 5),
        // Text(
        //   "",
        //   style: TextStyle(fontSize: 16),
        //   textAlign: TextAlign.center,
        // ),
        Text(
          "Log in to your account",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
