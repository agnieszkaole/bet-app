import 'package:bet_app/src/models/league_standings.dart';

import 'package:bet_app/src/provider/standings_provider.dart';
import 'package:bet_app/src/services/match_api.dart';

import 'package:bet_app/src/widgets/standings_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StandingsList extends StatefulWidget {
  StandingsList({
    super.key,
    required this.leagueNumber,
    this.isSelectedLeague,
  });

  final String? leagueNumber;
  final bool? isSelectedLeague;

  static final GlobalKey<_StandingsListState> nextMatchListKey = GlobalKey<_StandingsListState>();
  @override
  State<StandingsList> createState() => _StandingsListState();
}

class _StandingsListState extends State<StandingsList> {
  final ScrollController _scrollController = ScrollController();

  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  @override
  void didUpdateWidget(StandingsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.leagueNumber != oldWidget.leagueNumber) {
      _getData();
    }
  }

  Future<List<LeagueStandings>> _getData() async {
    final season1Data = await MatchApi().getStandings(
      widget.leagueNumber,
      '2023',
    );

    final season2Data = await MatchApi().getStandings(
      widget.leagueNumber,
      '2024',
    );
    final season3Data = await MatchApi().getStandings(
      widget.leagueNumber,
      '2025',
    );

    List<LeagueStandings> mergedData = [];
    // print(mergedData);

    mergedData.addAll(season1Data);
    mergedData.addAll(season2Data);
    mergedData.addAll(season3Data);

    Provider.of<StandingsProvider>(context, listen: false).saveStandings(mergedData);
    // print(mergedData);
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
              return const SizedBox(
                height: 160,
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 140,
                    child: Consumer<StandingsProvider>(builder: (context, provider, _) {
                      return ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: provider.standingsList.length,
                        itemBuilder: (context, index) {
                          return StandingsItem(
                            standings: provider.standingsList[index],
                          );
                        },
                      );
                    }),
                  )
                ],
              );
            }
          }
          return const SizedBox(
            height: 140,
            child: Center(
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
