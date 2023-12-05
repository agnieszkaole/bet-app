import 'package:bet_app/models/match_data.dart';
import 'package:bet_app/widgets/predict_result_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd.MM.yyyy HH:mm');

class MatchItem extends StatefulWidget {
  const MatchItem({
    super.key,
    required this.matchData,
  });

  final MatchData matchData;

  @override
  State<MatchItem> createState() => _MatchItemState();
}

class _MatchItemState extends State<MatchItem> {
  @override
  Widget build(BuildContext context) {
    final team1 = widget.matchData.team1.toString();
    final team2 = widget.matchData.team2.toString();
    final matchTime = widget.matchData.matchTime;

    return Card(
      color: const Color.fromARGB(255, 43, 43, 43),
      margin: const EdgeInsets.all(10.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatter.format(matchTime).toString()),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        team1,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.sports_soccer,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "vs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.sports_soccer,
                          size: 30,
                        ),
                      ),
                      Text(
                        team2,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              // width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PredictResultItem(
                        teamPrediction1: team1,
                        teamPrediction2: team2,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Colors.white, //change background color of button
                  backgroundColor: const Color.fromARGB(
                      255, 40, 122, 43), //change text color of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5.0,
                ),
                child: const Text('Wytypuj wynik'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
