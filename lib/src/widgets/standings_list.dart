// import 'package:bet_app/src/models/match_ranking.dart';
// import 'package:bet_app/src/provider/standings_provider.dart';
// import 'package:bet_app/src/services/soccer_api.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class StandingsList extends StatefulWidget {
//   StandingsList({
//     super.key,
//   });

//   @override
//   State<StandingsList> createState() => _StandingsListState();
// }

// class _StandingsListState extends State<StandingsList> {
//   final ScrollController _scrollController = ScrollController();
//   late Future dataFuture;

//   @override
//   void initState() {
//     super.initState();
//     dataFuture = _getData();
//   }

//   Future<List<MatchRanking>> _getData() async {
//     final season1Data = await SoccerApi().getStandings(
//       league: '106',
//       season: '2023',
//     );
//     final season2Data = await SoccerApi().getStandings(
//       league: '106',
//       season: '2024',
//     );

//     List<MatchRanking> mergedData = [];

//     mergedData.addAll(season1Data);
//     mergedData.addAll(season2Data);

//     Provider.of<StandingsProvider>(context, listen: false).saveStandings(mergedData);
//     return mergedData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: dataFuture,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasError) {
//               final error = snapshot.error;
//               return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 66, 66), fontSize: 20));
//             } else if (snapshot.data!.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'There are no ranking to display.',
//                   style: TextStyle(fontSize: 20),
//                   textAlign: TextAlign.center,
//                 ),
//               );
//             } else if (snapshot.hasData) {
//               final List rankingList = snapshot.data!;
//               print(rankingList);

//               // return Text(rankings[0].standing.team.name);
//             }
//           }
//           return const Center(
//             child: Text(
//               'Unexpected state encountered. Please try again later.',
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//           );
//         });
//   }
// }
