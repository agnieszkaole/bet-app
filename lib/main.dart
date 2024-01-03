import 'package:bet_app/provider/bottom_navigation_provider.dart';
import 'package:bet_app/provider/next_matches_provider.dart';
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
  final minWidth = 500.0;
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PredictedMatchProvider()),
        ChangeNotifierProvider(create: (context) => NextMatchesProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
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
          routes: {
            // '/getApiData': (context) => GetApiData(),
            // '/home': (context) => HomeScreen(),
            // '/nextMatchList': (context) => NextMatchList(
            //       matches: [],
            //     ),
            // '/matchesList': (context) => const NextMatchItem(
            //       isNewMatch: null,
            //     ),
          },

          home: HomeScreen(),
          // home: const SignupScreen(),
          // home: const LoginScreen(),
        ),
      ),
    );
  }
}
