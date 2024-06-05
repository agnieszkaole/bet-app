import 'package:bet_app/src/models/match_predictions_model.dart';

import 'package:flutter/material.dart';

class MatchPredictionItem extends StatefulWidget {
  const MatchPredictionItem({super.key, required this.prediction, required this.teams, required this.comparison});

  final Prediction prediction;
  final TeamsData teams;
  final Comparison comparison;

  @override
  State<MatchPredictionItem> createState() => _MatchPredictionItemState();
}

class _MatchPredictionItemState extends State<MatchPredictionItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(150, 62, 155, 19),
                Color.fromARGB(150, 31, 77, 10),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color.fromARGB(255, 102, 102, 102), width: 0.4),
            // image: const DecorationImage(
            //   image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'BetSprint advice',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                widget.prediction.advice,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              // SizedBox(height: 15),
            ],
          ),
        ),
        // SizedBox(height: 20),
      ],
    );
  }
}
