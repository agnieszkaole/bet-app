import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_group_matches_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';

import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/match_api.dart';

import 'package:bet_app/src/widgets/group_match_item.dart';
import 'package:bet_app/src/widgets/predicted_matches_preview.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class GroupMatchList extends StatefulWidget {
  GroupMatchList({
    super.key,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
    this.selectedDate,
    this.groupId,
    this.isCalendarVisible,
  });

  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;
  final String? selectedDate;
  final String? groupId;
  final bool? isCalendarVisible;

  static final GlobalKey<_GroupMatchListState> nextMatchListKey = GlobalKey<_GroupMatchListState>();

  @override
  State<GroupMatchList> createState() => _GroupMatchListState();
}

class _GroupMatchListState extends State<GroupMatchList> {
  late Future dataFuture;
  String? statusApi = '';
  User? user = Auth().currentUser;
  String? timezoneApi = 'Europe/Warsaw';
  // List<SoccerMatch>? mergedData;
  // final ScrollController _scrollController = ScrollController();
  late ScrollController _scrollController;
  String displayedItems = '30';
  // DateTime? selectedDate;
  // bool? showCalendar;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    dataFuture = _getData();
  }

  @override
  void didUpdateWidget(GroupMatchList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate || oldWidget.isCalendarVisible != widget.isCalendarVisible) {
      setState(() {
        dataFuture = _getData();
      });
    }
  }

  // Future<List<SoccerMatch>> _getData() async {
  //   if (widget.selectedDate == DateFormat('d MMMM yyyy').format(DateTime.now())) {
  //     final season1Data = await SoccerApi().getMatches(
  //       null,
  //       league: widget.leagueNumber,
  //       season: '2023',
  //       status: 'ns-tbd',
  //       timezone: timezoneApi,
  //       next: displayedItems,
  //     );
  //     final season2Data = await SoccerApi().getMatches(
  //       null,
  //       league: widget.leagueNumber,
  //       season: '2024',
  //       status: 'ns-tbd',
  //       timezone: timezoneApi,
  //       next: displayedItems,
  //     );

  //     List<SoccerMatch> mergedData = [];

  //     mergedData.addAll(season1Data);
  //     mergedData.addAll(season2Data);

  //     Provider.of<NextGroupMatchesProvider>(context, listen: false).saveMatches(mergedData);
  //     print(mergedData);
  //     return mergedData;
  //   } else {
  //     final season1Data = await SoccerApi().getMatches(
  //       widget.selectedDate,
  //       league: widget.leagueNumber,
  //       season: '2023',
  //       status: statusApi,
  //       timezone: timezoneApi,
  //     );
  //     final season2Data = await SoccerApi().getMatches(
  //       widget.selectedDate,
  //       league: widget.leagueNumber,
  //       season: '2024',
  //       status: statusApi,
  //       timezone: timezoneApi,
  //     );

  //     List<SoccerMatch> mergedData = [];

  //     mergedData.addAll(season1Data);
  //     mergedData.addAll(season2Data);

  //     Provider.of<NextGroupMatchesProvider>(context, listen: false).saveMatches(mergedData);

  //     return mergedData;
  //   }
  // }

  Future<List<SoccerMatch>> _getData() async {
    List<SoccerMatch> mergedData = [];

    if (!widget.isCalendarVisible!) {
      final season1Data = await MatchApi().getMatches(
        "",
        league: widget.leagueNumber,
        season: '2023',
        status: 'ns-tbd-1H-HT-2H-ET-BT-P-SUSP-INT',
        timezone: timezoneApi,
        // next: displayedItems,
      );
      final season2Data = await MatchApi().getMatches(
        "",
        league: widget.leagueNumber,
        season: '2024',
        status: 'ns-tbd-1H-HT-2H-ET-BT-P-SUSP-INT',
        timezone: timezoneApi,
        // next: displayedItems,
      );
      final season3Data = await MatchApi().getMatches(
        "",
        league: widget.leagueNumber,
        season: '2025',
        status: 'ns-tbd-1H-HT-2H-ET-BT-P-SUSP-INT',
        timezone: timezoneApi,
        // next: displayedItems,
      );

      mergedData.addAll(season1Data);
      mergedData.addAll(season2Data);
      mergedData.addAll(season3Data);
      Provider.of<NextGroupMatchesProvider>(context, listen: false).saveMatches(mergedData);
    } else {
      final season1Data = await MatchApi().getMatches(
        widget.selectedDate,
        league: widget.leagueNumber,
        season: '2023',
        status: 'ns-tbd-1H-HT-2H-ET-BT-P-SUSP-INT',
        timezone: timezoneApi,
      );
      final season2Data = await MatchApi().getMatches(
        widget.selectedDate,
        league: widget.leagueNumber,
        season: '2024',
        status: 'ns-tbd-1H-HT-2H-ET-BT-P-SUSP-INT',
        timezone: timezoneApi,
      );
      final season3Data = await MatchApi().getMatches(
        widget.selectedDate,
        league: widget.leagueNumber,
        season: '2025',
        status: 'ns-tbd-1H-HT-2H-ET-BT-P-SUSP-INT',
        timezone: timezoneApi,
      );

      mergedData.addAll(season1Data);
      mergedData.addAll(season2Data);
      mergedData.addAll(season3Data);
      Provider.of<NextGroupMatchesProvider>(context, listen: false).saveMatches(mergedData);
    }

    // Provider.of<NextGroupMatchesProvider>(context, listen: false).saveMatches(mergedData);
    return mergedData;
  }

  @override
  Widget build(BuildContext context) {
    late List<SoccerMatch> nextGroupMatchesList = context.watch<NextGroupMatchesProvider>().nextMatchesList;

    return FutureBuilder(
        future: dataFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'There are no matches on selected date or an unexpected error occurred.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              final predictedMatchProvider = Provider.of<PredictedMatchProvider>(context);

              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: RawScrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  trackColor: const Color.fromARGB(43, 40, 122, 43),
                  thumbColor: const Color.fromARGB(255, 40, 122, 43),
                  controller: _scrollController,
                  radius: const Radius.circular(10),
                  crossAxisMargin: 2,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: nextGroupMatchesList.length,
                    itemBuilder: (context, index) {
                      User? user = FirebaseAuth.instance.currentUser;
                      NextMatchesProvider.sortMatchesByDate(nextGroupMatchesList);
                      final match = nextGroupMatchesList[index];
                      // final isMatchAdded =
                      //     predictedMatchProvider.isMatchAdded(match.fixture.id, widget.groupId, user!.uid);

                      // return GroupMatchItem(
                      //   match: match,
                      //   isMatchAdded: isMatchAdded,
                      //   groupId: widget.groupId,
                      //   selectedLeagueNumber: widget.leagueName,
                      // );
                      Future<bool> getIsMatchAdded() async {
                        final querySnapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .collection('predictions')
                            .where('matchId', isEqualTo: nextGroupMatchesList[index].fixture.id)
                            .where('groupId', isEqualTo: widget.groupId)
                            .limit(1)
                            .get();
                        // setState(() {});
                        return querySnapshot.docs.isNotEmpty;
                      }

                      return FutureBuilder<bool>(
                        future: getIsMatchAdded(),
                        builder: (context, snapshot) {
                          final isMatchAdded = snapshot.data ?? false;

                          if (index < nextGroupMatchesList.length) {
                            return GroupMatchItem(
                                match: nextGroupMatchesList[index],
                                isMatchAdded: isMatchAdded,
                                groupId: widget.groupId,
                                selectedLeagueNumber: widget.leagueName);
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            }
          }
          return const Center(
            child: Text(
              'Unexpected state encountered. Please try again later.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
