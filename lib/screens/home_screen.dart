import 'package:bet_app/screens/matches_screen.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  List<Widget> pages = const [
    MatchesScreen(),
    MatchesScreen(),
    MatchesScreen(),
    MatchesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          'Bet',
          style: TextStyle(
            fontSize: 25,
          ),
        )),
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
              icon: Icon(Icons.calendar_month),
              label: 'Mecze',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_add_outlined,
              ),
              label: 'Typy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recent_actors_outlined),
              label: 'Wyniki',
              //
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recent_actors_outlined),
              label: 'Ranking',
              //
            ),
          ],
        ),
      ),
    );
  }
}
