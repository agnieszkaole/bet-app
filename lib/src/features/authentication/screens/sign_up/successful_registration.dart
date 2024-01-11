import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class SuccessfulRegistration extends StatelessWidget {
  const SuccessfulRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Udało się!',
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(height: 10),
              Text(
                'Rejestracja przebiegła pomyślnie.',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
