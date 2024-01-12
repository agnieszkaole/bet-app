import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/predicted_screen.dart';
import 'package:bet_app/src/screens/ranking_screen.dart';
import 'package:bet_app/src/screens/select_criteria_screen.dart';
import 'package:bet_app/src/screens/user_account.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/widgets/main_drawer.dart';
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
  late bool isAnonymous = true;
  late String email = '';

  @override
  void initState() {
    super.initState();
    Auth.checkUserStatus().then((result) {
      setState(() {
        isAnonymous = result;
      });
    });
  }

  Future<void> someFunction() async {
    Map<String, dynamic> result = await Auth.checkUserStatus();
    bool? isAnonymous = result['isAnonymous'];
    String? userEmail = result['email'];

    if (isAnonymous != null) {
      if (isAnonymous) {
        print('User is logged in anonymously');
      } else {
        print('User is logged in with email: $userEmail');
      }
    } else {
      print('No user is currently logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(currentPage);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // Text(userEmail ?? 'Niezalogowany'),
            IconButton(
              onPressed: () {
                // Navigator.of(context).pop();

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
                      color: Color.fromARGB(255, 53, 163, 57),
                    ),
            ),
          ],
          title: const Text(
            'Bet',
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
                icon: Icon(Icons.group),
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
