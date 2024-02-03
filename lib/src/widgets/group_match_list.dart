import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/group_match_item.dart';
// import 'package:bet_app/provider/predicted_match_provider.dart';
// import 'package:bet_app/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/next_match_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class GroupMatchList extends StatefulWidget {
  const GroupMatchList({
    super.key,
    this.matches,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
  });

  final List<SoccerMatch>? matches;
  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;

  static final GlobalKey<_GroupMatchListState> nextMatchListKey =
      GlobalKey<_GroupMatchListState>();

  @override
  State<GroupMatchList> createState() => _GroupMatchListState();
}

class _GroupMatchListState extends State<GroupMatchList> {
  final ScrollController _scrollController = ScrollController();
  int displayedItems = 20;
  bool isLoading = true;
  bool hasFetchedData = false;
  bool isNewMatch = true;

  @override
  void initState() {
    super.initState();
    // fetchDataForNewLeague(widget.leagueNumber);
    fetchDataForNewLeague('960');
  }

  // void updateLeagueNumber(String? newLeagueNumber) {
  //   setState(() {
  //     selectedLeagueNumber = newLeagueNumber;
  //   });

  //   ApiData getApiDataScreen = ApiData(leagueNumber: selectedLeagueNumber);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => getApiDataScreen),
  //   );
  // }

  Future fetchDataForNewLeague(String? leagueNumber) async {
    try {
      List<SoccerMatch> data = await SoccerApi().getMatches(leagueNumber);
      setState(() {
        isLoading = false;
        hasFetchedData = true;
        isNewMatch = false;
      });

      return data;
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    late List<SoccerMatch> nextMatchesList =
        context.watch<NextMatchesProvider>().nextMatchesList;

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasFetchedData
              ? Column(
                  children: [
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
                            NextMatchesProvider.sortMatchesByDate(
                                nextMatchesList);
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
                  ],
                )
              : const Center(
                  child: Text(
                    'Nie znaleziono żadnych meczów.\nZmień kryteria wyszukiwania.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
    );
  }
}
