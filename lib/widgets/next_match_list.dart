import 'package:bet_app/constants/league_names.dart';
import 'package:bet_app/models/soccermodel.dart';
import 'package:bet_app/provider/next_matches_provider.dart';
import 'package:bet_app/widgets/data_picker.dart';
import 'package:bet_app/widgets/main_drawer.dart';
// import 'package:bet_app/provider/predicted_match_provider.dart';
// import 'package:bet_app/widgets/data_picker.dart';
import 'package:bet_app/widgets/next_match_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class NextMatchList extends StatefulWidget {
  const NextMatchList({super.key, this.matches, this.leagueName});
  final List<SoccerMatch>? matches;
  final String? leagueName;

  @override
  State<NextMatchList> createState() => _NextMatchListState();
}

class _NextMatchListState extends State<NextMatchList> {
  // bool? isSelected;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final nextMatchesList =
        context.watch<NextMatchesProvider>().nextMatchesList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Powrót do wyboru ligi',
          style: TextStyle(fontSize: 15),
        ),
      ),
      // drawer: const MainDrawer(),
      body: (nextMatchesList.isEmpty)
          ? const Center(
              child: Text(
                'Nie znaleziono żadnych meczów.\nZmień kryteria wyszukiwania',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          // const Center(
          //     child: CircularProgressIndicator(),
          //   )
          : Column(
              children: [
                // const DataPicker(),
                Text(
                  widget.leagueName!,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
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
                        itemCount: nextMatchesList.length,
                        itemBuilder: (context, index) {
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
                const SizedBox(height: 25),
              ],
            ),
    );
  }
}
