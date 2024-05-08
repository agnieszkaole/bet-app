import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "GreatBet",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
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
