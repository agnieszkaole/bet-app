import 'package:bet_app/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ContinueAsGuestScreen extends StatelessWidget {
  const ContinueAsGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      },
      child: const Text(
        'Kontynuuj jako gość',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
