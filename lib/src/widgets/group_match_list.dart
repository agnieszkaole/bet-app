import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/group_match_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupMatchList extends StatefulWidget {
  GroupMatchList({
    super.key,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
  });

  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;

  static final GlobalKey<_GroupMatchListState> nextMatchListKey = GlobalKey<_GroupMatchListState>();
  @override
  State<GroupMatchList> createState() => _GroupMatchListState();
}

class _GroupMatchListState extends State<GroupMatchList> {
  final ScrollController _scrollController = ScrollController();
  int displayedItems = 20;

  DateTime _selectedDate = DateTime.now();
  String? formattedDate;
  late Future dataFuture;
  String? statusApi = 'ns-tbd';
  String? timezoneApi = 'Europe/Warsaw';
  // List<SoccerMatch>? mergedData;

  @override
  void initState() {
    super.initState();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      dataFuture = _getData();
    });
  }

  Future<List<SoccerMatch>> _getData() async {
    final season1Data = await SoccerApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2023',
      status: statusApi,
      timezone: timezoneApi,
    );
    final season2Data = await SoccerApi().getMatches(
      '',
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
                  'There are no matches to display in the selected league.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(height: 10),
                  Text(widget.leagueName!, style: TextStyle(fontSize: 24)),
                  DataPicker(
                    onDateSelected: (selectedDate) {
                      setState(() {
                        _selectedDate = selectedDate;
                        // formattedDate =
                        //     DateFormat('yyyy-MM-dd').format(_selectedDate);
                      });

                      // print(formattedDate);
                      // print(formattedDate);
                    },
                  ),
                  SizedBox(height: 10),
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
                        // itemCount: nextMatchesList.length,
                        itemCount: displayedItems,
                        itemBuilder: (context, index) {
                          NextMatchesProvider.sortMatchesByDate(nextMatchesList);
                          // NextMatchesProvider.showMatchesByDate(
                          //     _selectedDate);
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
                  if (displayedItems < nextMatchesList.length)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          displayedItems += 20;
                          if (displayedItems > nextMatchesList.length) {
                            displayedItems = nextMatchesList.length;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                        width: 0.8,
                        color: Color.fromARGB(255, 93, 202, 97),
                      )),
                      child: Text(
                        'Pokaż więcej (pozostało ${nextMatchesList.length - displayedItems})',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 93, 202, 97),
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),
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
