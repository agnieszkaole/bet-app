import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/next_match_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NextMatchList extends StatefulWidget {
  NextMatchList({
    super.key,
    required this.leagueNumber,
    required this.isSelectedLeague,
  });

  final String? leagueNumber;
  final bool isSelectedLeague;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming matches',
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const Text(
                  //   'Decide which matches you want to bet on.',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     // fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  SizedBox(height: 5),
                  Container(
                    height: 140,
                    child: Consumer<NextMatchesProvider>(builder: (context, provider, _) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: provider.nextMatchesList.length,
                        // itemCount: displayedItems,
                        itemBuilder: (context, index) {
                          NextMatchesProvider.sortMatchesByDate(provider.nextMatchesList);
                          if (index < nextMatchesList.length) {
                            return NextMatchItem(
                              match: provider.nextMatchesList[index],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    }),
                  )

                  // Container(
                  //   height: 140,
                  //   child: Consumer<NextMatchesProvider>(builder: (context, provider, _) {
                  //     if (provider.nextMatchesList.isEmpty) {
                  //       return CircularProgressIndicator(); // Display a loading indicator
                  //     }

                  //     // If nextMatchesList is not empty, display CarouselSlider
                  //     return CarouselSlider.builder(
                  //       itemCount: provider.nextMatchesList.length,
                  //       itemBuilder: (context, index, _) {
                  //         return NextMatchItem(match: provider.nextMatchesList[index]);
                  //       },
                  //       options: CarouselOptions(
                  //         height: 380.0,

                  //         // enlargeCenterPage: true,
                  //         // autoPlay: true,
                  //         aspectRatio: 16 / 9,

                  //         // autoPlayCurve: Curves.fastOutSlowIn,
                  //         enableInfiniteScroll: false,
                  //         // autoPlayAnimationDuration: Duration(milliseconds: 800),
                  //         viewportFraction: 0.5,
                  //       ),
                  //     );
                  //   }),
                  // )

//////////////////////////
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
