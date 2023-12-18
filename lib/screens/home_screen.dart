import 'package:bet_app/screens/groups_screen.dart';
import 'package:bet_app/screens/next_matches_screen.dart';
import 'package:bet_app/screens/predicted_screen.dart';
import 'package:bet_app/screens/prev_matches_screen.dart';
import 'package:bet_app/widgets/main_drawer.dart';
import 'package:bet_app/widgets/next_match_list.dart';
import 'package:bet_app/widgets/predicted_item.dart';
import 'package:bet_app/widgets/predicted_list.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  List<Widget> pages = [
    const NextMatchesScreen(),
    const PredictedScreen(),
    const GroupsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Betapp',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        drawer: const MainDrawer(),
        body: IndexedStack(
          index: currentPage,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          currentIndex: currentPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer),
              label: 'Mecze',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.handshake_outlined,
              ),
              label: 'Zakłady',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Grupy',
              //
            ),
          ],
        ),
      ),
    );
  }
}
