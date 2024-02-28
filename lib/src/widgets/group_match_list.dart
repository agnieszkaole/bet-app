import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/group_match_item.dart';
import 'package:bet_app/src/widgets/match_scheduled.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMatchList extends StatefulWidget {
  GroupMatchList({super.key, this.leagueName, this.leagueNumber, this.leagueLogo, this.selectedDate});

  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;
  final String? selectedDate;

  static final GlobalKey<_GroupMatchListState> nextMatchListKey = GlobalKey<_GroupMatchListState>();
  @override
  State<GroupMatchList> createState() => _GroupMatchListState();
}

class _GroupMatchListState extends State<GroupMatchList> {
  late Future dataFuture;
  String? statusApi = 'ns-tbd';
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

    Provider.of<NextMatchesProvider>(context, listen: false).saveMatches(mergedData);

    return mergedData;
  }

  @override
  Widget build(BuildContext context) {
    late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;

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
                  'There are no matches on selected date',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              return SizedBox(
                // height: MediaQuery.of(context).size.height,
                height: 500,
                child: Column(children: [
                  Expanded(
                    child: RawScrollbar(
                      // thumbVisibility: true,
                      trackVisibility: true,
                      trackColor: const Color.fromARGB(43, 40, 122, 43),
                      thumbColor: const Color.fromARGB(255, 40, 122, 43),
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      crossAxisMargin: 2,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: nextMatchesList.length,
                        itemBuilder: (context, index) {
                          NextMatchesProvider.sortMatchesByDate(nextMatchesList);
                          if (index < nextMatchesList.length) {
                            return GroupMatchItem(
                              match: nextMatchesList[index],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ]),
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
