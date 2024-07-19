import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/leaderboard_screen.dart';

import 'package:bet_app/src/screens/select_criteria_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  String? username = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    initUserDetails();
  }

  Future<void> _fetchUserData() async {
    User? user = Auth().currentUser;
    if (user != null) {
      setState(() {
        isAnonymous = user.isAnonymous;
        // username = firebaseUsername ?? '';
      });
    } else {
      print('No user is currently logged in');
    }
  }

  Future<void> initUserDetails() async {
    setState(() {
      User? user = Auth().currentUser;
      if (user != null) {
        isAnonymous = user.isAnonymous;
      }
    });
    username = await UserData().getUserDataFromFirebase();
    setState(() {});
  }

  void showLoginScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  Future<void> signOut() async {
    await Auth().signOutUserAccount();
    print('User is logged out: ${user!.uid}');

    showLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          // backgroundColor: Color.fromARGB(100, 0, 0, 0),
          backgroundColor: Colors.transparent,
          surfaceTintColor: const Color.fromARGB(255, 26, 26, 26),
          // flexibleSpace: const Center(
          //   child: Padding(
          //     padding: EdgeInsets.all(10.0),
          //     child: Text(
          //       'BetSprint',
          //       style: TextStyle(fontSize: 24),
          //     ),
          //   ),
          // ),
          // title: Image.asset(
          //   './assets/logo/logo.png',
          //   width: 200,
          // ),
          title: const Text(
            'BETsprint',
            style: TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat-BoldItalic',
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          // actions: [
          //   Icon(
          //     Icons.account_circle,
          //     size: 45,
          //     color: Color.fromARGB(255, 0, 155, 64),
          //   ),
          // ],
        ),
        body: Consumer<BottomNavigationProvider>(
          builder: (context, provider, _) {
            return Container(
              // constraints: BoxConstraints(maxWidth: kIsWeb ? 700.0 : MediaQuery.of(context).size.width),
              child: IndexedStack(
                index: provider.selectedIndex,
                children: const [
                  SelectCriteriaScreen(),
                  GroupsScreen(),
                  // LeagueOverviewScreen(),
                  LeaderboardScreen(),
                ],
              ),
            );
          },
        ),
        drawer: const MainDrawer(),
        bottomNavigationBar: Consumer<BottomNavigationProvider>(builder: (context, provider, _) {
          return Container(
            // constraints: BoxConstraints(
            //   maxWidth: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
            // ),
            child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(100, 0, 0, 0),
              selectedItemColor: const Color.fromARGB(220, 1, 207, 40),
              type: BottomNavigationBarType.fixed,
              currentIndex: provider.selectedIndex,
              onTap: (index) {
                provider.updateIndex(index);
                if (index == 0 || index == 1 || index == 2) {
                  // provider.updateIndex(index);
                } else if (index == 3) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: const Text('Not available in freemium plan. Upgrade your plan.'),
                  //     // content: const Text('Zaloguj się aby korzystać z tych funkcji.'),
                  //     // action: SnackBarAction(
                  //     //   label: 'Zaloguj',
                  //     //   onPressed: () {
                  //     //     Navigator.of(context).push(MaterialPageRoute(
                  //     //       builder: (context) => const LoginScreen(),
                  //     //     ));
                  //     //   },
                  //     // ),
                  //   ),
                  // );
                }
              },
              items: const [
                BottomNavigationBarItem(
                  // icon: Icon(Icons.emoji_events_rounded),
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      // Icons.scoreboard_outlined,
                      Icons.groups_2_rounded),
                  label: 'Groups',
                  //
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.scoreboard_outlined),
                //   // Icons.text_snippet_rounded),
                //   label: 'Leagues',
                //   //
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium_rounded),
                  label: 'Leaderboard',
                  //
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
