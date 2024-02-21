import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/next_match_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NextMatchList extends StatefulWidget {
  NextMatchList({
    super.key,
  });

  static final GlobalKey<_NextMatchListState> nextMatchListKey = GlobalKey<_NextMatchListState>();
  @override
  State<NextMatchList> createState() => _NextMatchListState();
}

class _NextMatchListState extends State<NextMatchList> {
  final ScrollController _scrollController = ScrollController();
  String? selectedLeagueNumber;
  int displayedItems = 20;
  // DateTime _selectedDate = DateTime.now();
  String? formattedDate;
  late Future dataFuture;
  String? statusApi = 'ns-tbd';
  String? timezoneApi = 'Europe/Warsaw';
  // String? league = '106';

  @override
  void initState() {
    super.initState();
    selectedLeagueNumber = '106';
    setState(() {
      dataFuture = _getData();
    });
  }

  Future<List<SoccerMatch>> _getData() async {
    final season1Data = await SoccerApi().getMatches(
      '',
      league: selectedLeagueNumber,
      season: '2023',
      status: statusApi,
      next: '10',
      timezone: timezoneApi,
    );
    final season2Data = await SoccerApi().getMatches(
      '',
      league: selectedLeagueNumber,
      season: '2024',
      status: statusApi,
      next: '10',
      timezone: timezoneApi,
    );

    List<SoccerMatch> mergedData = [];

    mergedData.addAll(season1Data);
    mergedData.addAll(season2Data);

    Provider.of<NextMatchesProvider>(context, listen: false).saveMatches(mergedData);

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
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'There are no matches to display in the selected league.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              List<SoccerMatch> nextMatchesList = snapshot.data!;
              return Column(
                children: [
                  SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final league in leagueNames)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(255, 53, 53, 53),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 0.5),
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color.fromARGB(146, 0, 199, 90),
                                  Color.fromARGB(108, 0, 92, 41),
                                ],
                              ),
                            ),
                            child: Center(
                              child: GestureDetector(
                                child: Text(league["name"]),
                                onTap: () {
                                  setState(() {
                                    selectedLeagueNumber = league['number'].toString();
                                  });
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      // itemCount: nextMatchesList.length,
                      itemCount: displayedItems,
                      itemBuilder: (context, index) {
                        NextMatchesProvider.sortMatchesByDate(nextMatchesList);
                        if (index < nextMatchesList.length) {
                          return NextMatchItem(
                            match: nextMatchesList[index],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
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
