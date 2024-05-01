import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/match_prediction_list.dart';
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
    final season1Data = await SoccerApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2023',
      status: statusApi,
      next: '15',
      timezone: timezoneApi,
    );
    final season2Data = await SoccerApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2024',
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

    int availableMatches = mergedData.length;
    int requestedMatches = 10;

    if (availableMatches > requestedMatches) {
      mergedData = mergedData.sublist(0, requestedMatches);
    }
    Provider.of<NextMatchesProvider>(context, listen: false).saveMatches(mergedData);

    return mergedData;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.leagueNumber);
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
              return SizedBox(
                height: 150,
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
            } else if (snapshot.hasData) {
              if (snapshot.data != []) {
                return Container(
                  height: 310,
                  padding: const EdgeInsets.only(left: 5, top: 10, right: 15, bottom: 10),
                  decoration: BoxDecoration(
                      // color: Color.fromARGB(118, 51, 51, 51),
                      // border: Border.all(
                      //   width: .5,
                      //   color: Color.fromARGB(224, 102, 102, 102),
                      // ),
                      // borderRadius: BorderRadius.all(
                      //   Radius.circular(25),
                      // ),
                      ),
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Consumer<NextMatchesProvider>(builder: (context, provider, _) {
                    return RawScrollbar(
                      interactive: true,
                      trackColor: const Color.fromARGB(43, 40, 122, 43),
                      thumbColor: Color.fromARGB(255, 0, 137, 223),
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
                            return const SizedBox();
                          }
                        },
                      ),
                    );
                  }),
                );
              } else {
                return const Center(
                  child: Text(
                    'There are no matches to display or an unexpected error occurred.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }
          }

          return SizedBox(
            height: 140,
            child: const Center(
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
