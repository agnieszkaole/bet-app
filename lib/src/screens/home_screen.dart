import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/predicted_screen.dart';
import 'package:bet_app/src/screens/ranking_screen.dart';
import 'package:bet_app/src/screens/select_criteria_screen.dart';
import 'package:bet_app/src/screens/user_account.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/widgets/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // User? user = Auth().currentUser;
  bool isAnonymous = true;
  String email = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = Auth().currentUser;
    if (user != null) {
      setState(() {
        isAnonymous = user.isAnonymous;
        email = user.email ?? "Gość";
      });
    } else {
      print('No user is currently logged in');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Text(email),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => UserAccountScreen(),
                  ),
                );
              },
              icon: isAnonymous
                  ? Icon(
                      Icons.account_circle,
                      size: 45,
                      color: Color.fromARGB(255, 163, 163, 163),
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 45,
                      color: Color.fromARGB(255, 59, 182, 63),
                    ),
            ),
          ],
          title: const Text(
            'Betapp',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        drawer: const MainDrawer(),
        body: Consumer<BottomNavigationProvider>(
          builder: (context, provider, _) {
            return IndexedStack(
              index: provider.selectedIndex,
              children: const [
                SelectCriteriaScreen(),
                PredictedScreen(),
                RankingScreen(),
                GroupsScreen(),
              ],
            );
          },
        ),
        bottomNavigationBar:
            Consumer<BottomNavigationProvider>(builder: (context, provider, _) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: provider.selectedIndex,
            onTap: (index) {
              // provider.updateIndex(index);
              if (!isAnonymous || (index == 0 || index == 1)) {
                provider.updateIndex(index);
              } else if (isAnonymous && (index == 2 || index == 3)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Zaloguj się aby korzystać z tych funkcji.'),
                    action: SnackBarAction(
                      label: 'Zaloguj',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                      },
                    ),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_rounded),
                label: 'Wybierz ligę',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.scoreboard_outlined,
                ),
                label: 'Twoje typy',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Ranking',
                //
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_rounded),
                label: 'Grupy',
                //
              ),
            ],
          );
        }),
      ),
    );
  }
}
