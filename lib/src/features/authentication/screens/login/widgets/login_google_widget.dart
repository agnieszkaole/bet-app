import 'package:flutter/material.dart';

class LoginGoogle extends StatelessWidget {
  const LoginGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(255, 228, 228, 228),
        border: Border.all(
          color: const Color.fromARGB(255, 40, 122, 43),
        ),
        boxShadow: const [
          BoxShadow(

              // color: Colors.white.withOpacity(0.5),
              // spreadRadius: 1,
              // blurRadius: 1,
              // offset: const Offset(0, 1), // changes position of shadow
              ),
        ],
      ),
      child: TextButton(
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   height: 30.0,
            //   width: 30.0,
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(
            //             'assets/images/login_signup/google.png'),
            //         fit: BoxFit.cover),
            //     shape: BoxShape.circle,
            //   ),
            // ),
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
    );
  }
}
