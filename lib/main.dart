import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:bet_app/screens/home_screen.dart';
import 'package:bet_app/screens/predicted_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PredictedMatchProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
