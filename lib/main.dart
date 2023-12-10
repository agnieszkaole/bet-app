import 'package:bet_app/screens/home_screen.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hkhjkjh',
      theme: ThemeData.dark(
        useMaterial3: true,
        // colorScheme: ColorScheme.fromSeed(
        // brightness: Brightness.dark,
        // seedColor: Colors.grey,
        // ),
        // textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}
