import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/match_prediction_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchPredictionList extends StatefulWidget {
  MatchPredictionList({
    super.key,
    required this.leagueNumber,
    required this.matchId,
  });
  final String? leagueNumber;
  final String matchId;

  @override
  State<MatchPredictionList> createState() => _MatchPredictionListState();
}

class _MatchPredictionListState extends State<MatchPredictionList> {
  final ScrollController _scrollController = ScrollController();
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  @override
  void didUpdateWidget(MatchPredictionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.leagueNumber != oldWidget.leagueNumber) {
      _getData();
    }
  }

  Future<List<PredictionData>> _getData() async {
    final data = await SoccerApi().getPredictions(widget.matchId);
    return data;
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
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 66, 66), fontSize: 20));
          } else {
            late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
            final List<PredictionData> predictionsResponse = snapshot.data;

            final predictions = predictionsResponse[0].predictions;
            final teams = predictionsResponse[0].teams;
            final comparison = predictionsResponse[0].comparison;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Predictions',
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                // const Text(
                //   'Check out the latest football predictions.',
                //   style: TextStyle(
                //     fontSize: 14,
                //     // fontWeight: FontWeight.bold,
                //   ),
                // ),
                Container(
                  height: 300,
                  child: Consumer<NextMatchesProvider>(builder: (context, provider, _) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: provider.nextMatchesList.length,
                      // itemCount: displayedItems,
                      itemBuilder: (context, index) {
                        NextMatchesProvider.sortMatchesByDate(provider.nextMatchesList);
                        if (index < nextMatchesList.length) {
                          return MatchPredictionItem(
                            predictions: predictions,
                            teams: teams,
                            comparison: comparison,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  }),
                ),
              ],
            );
          }
        } else {
          return const Center(
            child: Text(
              'Unexpected state encountered. Please try again later.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
