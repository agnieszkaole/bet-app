import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/predicted_screen.dart';
import 'package:bet_app/src/screens/ranking_screen.dart';
import 'package:bet_app/src/screens/select_criteria_screen.dart';
import 'package:bet_app/src/screens/user_account.dart';
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
  @override
  Widget build(BuildContext context) {
    // print(currentPage);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => UserAccountScreen(),
                  ),
                );
              },
              icon: Icon(Icons.account_circle),
              iconSize: 30,
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
              provider.updateIndex(index);
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
