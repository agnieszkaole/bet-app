import 'package:bet_app/firebase_options.dart';
import 'package:bet_app/src/features/authentication/screens/auth/auth_screens.dart';
import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get firebaseAuth => null;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PredictedMatchProvider()),
        ChangeNotifierProvider(create: (context) => NextMatchesProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
      ],
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, minWidth: 300),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Betapp',
            // themeMode: ThemeMode.system,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              primaryColor: const Color.fromARGB(200, 40, 122, 43),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
            ),
            home: StreamBuilder<User?>(
                stream: firebaseAuth.authStateChanges(),
                builder: (context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // return HomeScreen();
                    return const AuthScreens();
                  } else {
                    return const LoginScreen();
                    // return const AuthScreens();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
