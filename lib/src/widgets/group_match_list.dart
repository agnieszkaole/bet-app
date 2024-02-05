import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/api_data.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/group_match_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMatchList extends StatefulWidget {
  GroupMatchList({
    super.key,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
  });

  final String? leagueName;
  final int? leagueNumber;
  final String? leagueLogo;

  @override
  State<GroupMatchList> createState() => _GroupMatchListState();
}

class _GroupMatchListState extends State<GroupMatchList> {
  final ScrollController _scrollController = ScrollController();
  int displayedItems = 20;
  bool isLoading = true;
  bool hasFetchedData = false;
  // late List<SoccerMatch> nextMatchesList;
  // bool isNewMatch = true;
  // int? selectedLeagueNumber;

  @override
  void initState() {
    super.initState();
    fetchDataForNewLeague(widget.leagueNumber);
    // fetchDataForNewLeague(960);
  }

  // Future fetchDataForNewLeague(int? leagueNumber) async {
  //   try {
  //     List<SoccerMatch> data = await SoccerApi().getMatches(leagueNumber);
  //     setState(() {
  //       isLoading = false;
  //       hasFetchedData = true;
  //       // isNewMatch = false;
  //     });
  //     ApiData(leagueNumber: leagueNumber);
  //     return data;
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return [];
  //   }
  // }

  Future fetchDataForNewLeague(int? leagueNumberr) async {
    setState(() {
      // isLoading = false;
      // hasFetchedData = true;
      // isNewMatch = false;
    });
    ApiData(leagueNumber: leagueNumberr);
  }

  @override
  Widget build(BuildContext context) {
    List<SoccerMatch> nextMatchesList =
        context.watch<NextMatchesProvider>().nextMatchesList;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : hasFetchedData == true
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
              );
  }
}
