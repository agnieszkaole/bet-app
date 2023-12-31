import 'package:bet_app/firebase_options.dart';
import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/features/authentication/screens/sign_up/singup_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      child: ConstrainedBox(
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

          // home: HomeScreen(),
          // home: const SignUpScreen(),
          // home: const LoginScreen(),

          home: StreamBuilder<User?>(
              stream: firebaseAuth.authStateChanges(),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return HomeScreen();
                } else {
                  return const LoginScreen();
                }
              }),
        ),
      ),
    );
  }
}
