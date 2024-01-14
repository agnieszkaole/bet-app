import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/soccer_api_service.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
// import 'package:bet_app/provider/predicted_match_provider.dart';
// import 'package:bet_app/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/next_match_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class NextMatchList extends StatefulWidget {
  const NextMatchList({
    super.key,
    this.matches,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
    // this.selectedDate
  });

  final List<SoccerMatch>? matches;
  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;
  // final DateTime? selectedDate;

  static final GlobalKey<_NextMatchListState> nextMatchListKey =
      GlobalKey<_NextMatchListState>();

  @override
  State<NextMatchList> createState() => _NextMatchListState();
}

class _NextMatchListState extends State<NextMatchList> {
  final ScrollController _scrollController = ScrollController();
  late DateTime _selectedDate;
  int displayedItems = 20;
  bool isLoading = true;
  bool hasFetchedData = false;

  @override
  void initState() {
    super.initState();
    fetchDataForNewLeague(widget.leagueNumber);

    // setState(() {
    // _selectedDate = widget.selectedDate;
    // });
  }

  Future fetchDataForNewLeague(String? leagueNumber) async {
    try {
      List<SoccerMatch> data = await SoccerApi().getMatches(leagueNumber);
      setState(() {
        isLoading = false;
        hasFetchedData = true;
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Provider.of<NextMatchesProvider>(context, listen: false)
                .clearMatches();
          },
        ),
      ),

      // drawer: const MainDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasFetchedData && nextMatchesList.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(10),
                  // width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 122, 43),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  // color: Color.fromARGB(255, 169, 224, 172),
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  widget.leagueLogo!,

                                  // width: 50.0,
                                  // height: 50.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.leagueName!,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const DataPicker(),
                      // const SizedBox(height: 10),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: RawScrollbar(
                            // thumbVisibility: true,
                            trackVisibility: true,
                            trackColor: Color.fromARGB(43, 40, 122, 43),
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
                                  return NextMatchItem(
                                    match: nextMatchesList[index],
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
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
                  ),
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
