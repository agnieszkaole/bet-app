import 'package:bet_app/provider/bottom_navigation_provider.dart';
import 'package:bet_app/screens/groups_screen.dart';
import 'package:bet_app/screens/next_matches_screen.dart';
import 'package:bet_app/screens/predicted_screen.dart';
import 'package:bet_app/screens/ranking_screen.dart';
import 'package:bet_app/screens/select_criteria_screen.dart';
import 'package:bet_app/widgets/main_drawer.dart';
import 'package:bet_app/widgets/next_match_list.dart';
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
                icon: Icon(Icons.category_rounded),
                label: 'Wydarzenia',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.handshake_outlined,
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
