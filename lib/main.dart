import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:bet_app/screens/home_screen.dart';
import 'package:bet_app/screens/login_screen.dart';
import 'package:bet_app/screens/signup_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PredictedMatchProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Betapp',
        theme: ThemeData(
          useMaterial3: true,
          // colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          // seedColor: Color.fromARGB(255, 39, 176, 46),
          // ),
          // textTheme: GoogleFonts.latoTextTheme(),
        ),
        // routes: {
        // '/': (context) => const NextMatchesScreen(),
        //   '/matchesList': (context) => const NextMatchItem(
        //         isNewMatch: null,
        //       ),
        // }
        // ,
        home: const HomeScreen(),
        // home: const SignupScreen(),
        // home: const LoginScreen(),
      ),
    );
  }
}
