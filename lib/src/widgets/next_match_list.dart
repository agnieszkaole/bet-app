import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/services/match_api.dart';

import 'package:bet_app/src/widgets/next_match_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextMatchList extends StatefulWidget {
  NextMatchList({
    super.key,
    required this.leagueNumber,
    this.isSelectedLeague,
  });

  final String? leagueNumber;
  final bool? isSelectedLeague;

  static final GlobalKey<_NextMatchListState> nextMatchListKey = GlobalKey<_NextMatchListState>();
  @override
  State<NextMatchList> createState() => _NextMatchListState();
}

class _NextMatchListState extends State<NextMatchList> {
  final ScrollController _scrollController = ScrollController();

  // String? leagueNumber;
  int displayedItems = 20;
  // DateTime _selectedDate = DateTime.now();
  String? formattedDate;
  late Future dataFuture;
  String? statusApi = 'ns-tbd';
  String? timezoneApi = 'Europe/Warsaw';

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  @override
  void didUpdateWidget(NextMatchList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.leagueNumber != oldWidget.leagueNumber) {
      _getData();
    }
  }

  Future<List<SoccerMatch>> _getData() async {
    final season1Data = await MatchApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2023',
      status: statusApi,
      next: '15',
      timezone: timezoneApi,
    );
    final season2Data = await MatchApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2024',
      status: statusApi,
      next: '15',
      timezone: timezoneApi,
    );
    final season3Data = await MatchApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2025',
      status: statusApi,
      next: '15',
      timezone: timezoneApi,
    );

    // final standings = await SoccerApi().getStandings(
    //   widget.leagueNumber,
    //   '2023',
    // );

    // print(standings);

    List<SoccerMatch> mergedData = [];

    mergedData.addAll(season1Data);
    mergedData.addAll(season2Data);
    mergedData.addAll(season3Data);

    // int availableMatches = mergedData.length;
    // int requestedMatches = 10;

    // if (availableMatches > requestedMatches) {
    //   mergedData = mergedData.sublist(0, requestedMatches);
    // }

    Provider.of<NextMatchesProvider>(context, listen: false).saveMatches(mergedData);
    print('next${mergedData}');
    return mergedData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dataFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
            }
            if (snapshot.data!.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cannot get next matches.',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'An unexpected error occurred',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              return Container(
                height: 340,
                padding: const EdgeInsets.only(left: 5, top: 20, right: 15, bottom: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(57, 80, 80, 80),
                  // border: Border.all(
                  //   width: 0.8,
                  //   color: Color.fromARGB(215, 69, 167, 24),
                  // ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Consumer<NextMatchesProvider>(builder: (context, provider, _) {
                  if (Provider.of<NextMatchesProvider>(context, listen: false).nextMatchesList.isNotEmpty) {
                    return RawScrollbar(
                      interactive: true,
                      trackColor: const Color.fromARGB(43, 40, 122, 43),
                      thumbColor: const Color.fromARGB(200, 62, 155, 19),
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: ListView.builder(
                          // scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          itemCount: provider.nextMatchesList.length,
                          itemBuilder: (context, index) {
                            NextMatchesProvider.sortMatchesByDate(provider.nextMatchesList);

                            if (index < provider.nextMatchesList.length) {
                              return NextMatchItem(
                                match: provider.nextMatchesList[index],
                              );
                            } else {
                              return null;
                            }
                          }),
                    );
                  } else {
                    return Center(
                        child: Text(
                      'There are no matches to display.',
                      style: TextStyle(fontSize: 18),
                    ));
                  }
                }),
              );
            }
          }
          return const SizedBox(
            height: 140,
            child: Center(
              child: Text(
                'Unexpected state encountered. Please try again later.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
  }
}
