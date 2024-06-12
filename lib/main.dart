import 'package:bet_app/firebase_options.dart';
import 'package:bet_app/src/features/authentication/screens/auth/auth_screens.dart';
import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/provider/match_id_provider.dart';
import 'package:bet_app/src/provider/next_group_matches_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/next_matches_scheduled_provider.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/provider/prev_matches_provider.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/provider/standings_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
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
        ChangeNotifierProvider(create: (context) => PrevMatchesProvider()),
        ChangeNotifierProvider(create: (context) => NextMatchesScheduledProvider()),
        ChangeNotifierProvider(create: (context) => NextGroupMatchesProvider()),
        ChangeNotifierProvider(create: (context) => ScoreboardProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (context) => MatchIdProvider()),
        ChangeNotifierProvider(create: (context) => StandingsProvider()),
      ],
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 3, 31),
                  // image: DecorationImage(
                  //   image: AssetImage('./assets/images/little-1506570_19201.png'),
                  //   fit: BoxFit.cover,
                  // ),
                  // gradient: const LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Color.fromARGB(255, 12, 12, 12),
                  //     Color.fromARGB(255, 13, 109, 23),
                  //   ],
                  // )
                ),
              ),
              MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'BETSprint',
                // themeMode: ThemeMode.system,
                theme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    // primaryColor: const Color.fromARGB(200, 40, 122, 43),
                    textTheme: Theme.of(context).textTheme.apply(
                          bodyColor: const Color.fromARGB(255, 255, 255, 255),
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                    dialogBackgroundColor: Color.fromARGB(255, 0, 3, 31),

                    // scaffoldBackgroundColor: Colors.transparent),
                    scaffoldBackgroundColor: Color.fromARGB(255, 0, 3, 31)),
                home: StreamBuilder<User?>(
                  stream: firebaseAuth.authStateChanges(),
                  builder: (context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return const AuthScreens();
                    } else {
                      return const LoginScreen();
                    }
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
