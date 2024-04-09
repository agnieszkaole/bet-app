import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/next_matches_scheduled_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/next_match_scheduled_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextMatchScheduledList extends StatefulWidget {
  NextMatchScheduledList({
    super.key,
    required this.leagueNumber,
    this.isSelectedLeague,
  });

  final String? leagueNumber;
  final bool? isSelectedLeague;

  static final GlobalKey<_NextMatchScheduledListState> nextMatchScheduleListKey =
      GlobalKey<_NextMatchScheduledListState>();
  @override
  State<NextMatchScheduledList> createState() => _NextMatchScheduledListState();
}

class _NextMatchScheduledListState extends State<NextMatchScheduledList> {
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
  void didUpdateWidget(NextMatchScheduledList oldWidget) {
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
      next: '10',
      timezone: timezoneApi,
    );
    final season2Data = await SoccerApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2024',
      status: statusApi,
      next: '10',
      timezone: timezoneApi,
    );

    List<SoccerMatch> mergedData = [];

    mergedData.addAll(season1Data);
    mergedData.addAll(season2Data);

    int availableMatches = mergedData.length;
    int requestedMatches = 10;

    if (availableMatches > requestedMatches) {
      mergedData = mergedData.sublist(0, requestedMatches);
    }
    Provider.of<NextMatchesScheduledProvider>(context, listen: false).saveMatches(mergedData);

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
              return const Center(
                child: Text(
                  'Unexpected error occured. Cannot get next matches dates.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              List<SoccerMatch> nextMatchesScheduledList = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Decide which matches you want to bet on.',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     // fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  SizedBox(height: 5),
                  Container(
                    height: 60,
                    child: Consumer<NextMatchesScheduledProvider>(builder: (context, provider, _) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: provider.nextMatchesScheduledList.length,
                        // itemCount: displayedItems,
                        itemBuilder: (context, index) {
                          NextMatchesProvider.sortMatchesByDate(provider.nextMatchesScheduledList);
                          if (index < nextMatchesScheduledList.length) {
                            return NextMatchScheduledItem(
                              match: provider.nextMatchesScheduledList[index],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 10)
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
