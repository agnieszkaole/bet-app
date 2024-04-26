import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          constraints: BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              width: 1,
              color: Color.fromARGB(255, 47, 56, 49),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GreateBet advice',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                widget.prediction.advice,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
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
