import "package:bet_app/src/provider/predicted_match_provider.dart";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PredictedMatchesPreview extends StatefulWidget {
  const PredictedMatchesPreview({
    Key? key,
    required this.leagueNumber,
    this.groupId,
    this.matchId,
  }) : super(key: key);

  final int? leagueNumber;
  final String? groupId;
  final int? matchId;

  @override
  State<PredictedMatchesPreview> createState() => _PredictedMatchesPreviewState();
}

class _PredictedMatchesPreviewState extends State<PredictedMatchesPreview> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PredictedMatchProvider>(
      builder: (context, predictedMatchProvider, _) {
        // Get the predicted matches list from the provider
        final predictedMatches = predictedMatchProvider.showMatchesByLeague(widget.leagueNumber);

        if (predictedMatches.isEmpty) {
          return const Center(
            child: Text(
              'No predictions found for this match.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        }

        return SizedBox(
          height: 70,
          child: ListView.builder(
            itemCount: predictedMatches.length,
            itemBuilder: (context, index) {
              final userPrediction = predictedMatches[index];
              final homeGoal = userPrediction['homeGoal'] as int;
              final awayGoal = userPrediction['awayGoal'] as int;

              return Column(
                children: [
                  const Divider(
                    height: 20,
                    thickness: 2,
                    endIndent: 10,
                    indent: 10,
                  ),
                  const Text('Your bet'),
                  const SizedBox(height: 5),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "$homeGoal",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        const Text(
                          ":",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          "$awayGoal",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
