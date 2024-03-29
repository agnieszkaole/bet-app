import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: const Column(
        children: [
          Text(
            "Betapp",
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
      ),
    );
  }
}
