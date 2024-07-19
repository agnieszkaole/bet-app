import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/match_api.dart';
import 'package:bet_app/src/widgets/match_prediction_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchPredictionList extends StatefulWidget {
  const MatchPredictionList({
    super.key,
    required this.leagueNumber,
    required this.matchId,
  });
  final String? leagueNumber;
  final String? matchId;

  static final GlobalKey<_MatchPredictionListState> nextMatchListKey = GlobalKey<_MatchPredictionListState>();

  @override
  State<MatchPredictionList> createState() => _MatchPredictionListState();
}

class _MatchPredictionListState extends State<MatchPredictionList> {
  // final ScrollController _scrollController = ScrollController();
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  @override
  void didUpdateWidget(MatchPredictionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // late final selectedMatchId = context.watch<MatchIdProvider>().selectedMatchId;
    // if (widget.leagueNumber != oldWidget.leagueNumber) {
    setState(() {
      dataFuture = _getData();
    });
    // }
  }

  Future<List<PredictionData>> _getData() async {
    //   final matchId = context.read<MatchIdProvider>().selectedMatchId;
    final data = await MatchApi().getPredictions(widget.matchId);
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
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            final error = snapshot.error;

            return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
          } else if (snapshot.data!.isEmpty) {
            return const SizedBox(
              height: 140,
              child: Center(
                child: Text(
                  'Cannot get next predictions.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data.isNotEmpty) {
              // late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
              final List<PredictionData> predictionsResponse = snapshot.data;
              final predictions = predictionsResponse[0].predictions;
              final teams = predictionsResponse[0].teams;
              final comparison = predictionsResponse[0].comparison;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    // height: 240,

                    child: Consumer<NextMatchesProvider>(builder: (context, provider, _) {
                      return MatchPredictionItem(
                        prediction: predictions,
                        teams: teams,
                        comparison: comparison,
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
      },
    );
  }
}
