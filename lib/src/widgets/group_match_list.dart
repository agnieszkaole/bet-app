import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_group_matches_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/group_match_item.dart';
import 'package:bet_app/src/widgets/match_scheduled.dart';
import 'package:bet_app/src/widgets/predict_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMatchList extends StatefulWidget {
  GroupMatchList({
    super.key,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
    this.selectedDate,
    this.groupId,
  });

  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;
  final String? selectedDate;
  final String? groupId;

  static final GlobalKey<_GroupMatchListState> nextMatchListKey = GlobalKey<_GroupMatchListState>();

  @override
  State<GroupMatchList> createState() => _GroupMatchListState();
}

class _GroupMatchListState extends State<GroupMatchList> {
  late Future dataFuture;
  String? statusApi = 'ns-tbd';
  User? user = Auth().currentUser;
  String? timezoneApi = 'Europe/Warsaw';
  // List<SoccerMatch>? mergedData;
  // final ScrollController _scrollController = ScrollController();
  late ScrollController _scrollController;
  int displayedItems = 20;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   dataFuture = _getData();
    // });
    _scrollController = ScrollController();
    dataFuture = _getData();
  }

  @override
  void didUpdateWidget(GroupMatchList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      setState(() {
        dataFuture = _getData();
      });
    }
  }

  Future<List<SoccerMatch>> _getData() async {
    final season1Data = await SoccerApi().getMatches(
      widget.selectedDate,
      league: widget.leagueNumber,
      season: '2023',
      status: statusApi,
      timezone: timezoneApi,
    );
    final season2Data = await SoccerApi().getMatches(
      widget.selectedDate,
      league: widget.leagueNumber,
      season: '2024',
      status: statusApi,
      timezone: timezoneApi,
    );

    List<SoccerMatch> mergedData = [];

    mergedData.addAll(season1Data);
    mergedData.addAll(season2Data);

    Provider.of<NextGroupMatchesProvider>(context, listen: false).saveMatches(mergedData);

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
              return SingleChildScrollView(
                child: SizedBox(
                  // height: MediaQuery.of(context).size.height,
                  height: 400,
                  child: Column(children: [
                    Expanded(
                      child: RawScrollbar(
                        // thumbVisibility: true,
                        // trackVisibility: true,
                        trackColor: const Color.fromARGB(43, 40, 122, 43),
                        thumbColor: const Color.fromARGB(255, 40, 122, 43),
                        controller: _scrollController,
                        radius: const Radius.circular(10),
                        crossAxisMargin: 2,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: nextGroupMatchesList.length,
                          itemBuilder: (context, index) {
                            Future<bool> getIsMatchAdded() async {
                              final querySnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .collection('predictions')
                                  .where('matchId', isEqualTo: nextGroupMatchesList[index].fixture.id)
                                  .where('groupId', isEqualTo: widget.groupId)
                                  .limit(1)
                                  .get();
                              setState(() {});
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
                                      groupId: widget.groupId);
                                } else {
                                  return SizedBox();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    // const SizedBox(height: 15),
                  ]),
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
