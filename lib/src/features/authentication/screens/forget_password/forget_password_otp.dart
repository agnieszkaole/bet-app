import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Weryfikacja '),
            const SizedBox(height: 20),
            const Text(
              'Wprowadź kod weryfikacyjny wysłany na adres: support@gmail.com',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OtpTextField(
              numberOfFields: 6,
              filled: true,
              fillColor: const Color.fromARGB(255, 40, 122, 43),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              focusedBorderColor: const Color.fromARGB(255, 55, 189, 59),
              onSubmit: (code) {
                print(code);
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                ),
                child: const Text(
                  "Wyślij",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
