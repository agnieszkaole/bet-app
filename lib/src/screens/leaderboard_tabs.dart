import "package:bet_app/src/screens/leaderboard_general.dart";
import "package:bet_app/src/screens/leaderboard_group.dart";
import "package:bet_app/src/screens/leaderboard_leagues.dart";
import "package:bet_app/src/screens/top_100.dart";
import "package:flutter/material.dart";

class LeaderboardTabs extends StatefulWidget {
  const LeaderboardTabs({super.key});

  @override
  State<LeaderboardTabs> createState() => _LeaderboardTabsState();
}

class _LeaderboardTabsState extends State<LeaderboardTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 20,
                  constraints: BoxConstraints(maxWidth: 600),
                  child: TabBar(
                    tabAlignment: TabAlignment.center,
                    padding: const EdgeInsets.only(bottom: 10),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.green,
                    indicatorWeight: 1.2,
                    labelColor: Colors.white,
                    dividerColor: Color.fromARGB(38, 255, 255, 255),
                    tabs: [
                      Tab(text: 'Top 10 ever '),
                      Tab(text: 'League leaders'),
                      Tab(text: 'Group leaders'),
                    ],
                  ))),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: Top100(),
            ),
            Container(
              child: LeaderboardLeagues(),
            ),
            Container(
              child: LeaderboardGroup(),
            ),
          ],
        ),
      ),
    );
  }
}

//  Column(children: [
//   ListTile(
//     title: Text('Nazwa uzytkownika'),
//     trailing: Text('67'),
//     leading: Text('1'),
//   ),
//   ListTile(
//     title: Text('Nazwa uzytkownika'),
//     trailing: Text('56'),
//     leading: Text('2'),
//   ),
//   ListTile(
//     title: Text('Nazwa uzytkownika'),
//     trailing: Text('48'),
//     leading: Text('3'),
//   ),
//   ListTile(
//     title: Text('Nazwa uzytkownika'),
//     trailing: Text('43'),
//     leading: Text('4'),
//   ),
//   ListTile(
//     title: Text('Nazwa uzytkownika'),
//     trailing: Text('35'),
//     leading: Text('5'),
//   ),
// ]),
