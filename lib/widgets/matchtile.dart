import 'package:bet_app/models/soccermodel.dart';
import 'package:bet_app/screens/predict_result_screen.dart';
import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget {
  final SoccerMatch match;

  MatchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    var homeGoal = match.goal.home;
    var awayGoal = match.goal.away;
    var elapsedTime = match.fixture.status.elapsedTime;
    if (homeGoal == null) homeGoal = 0;
    if (awayGoal == null) awayGoal = 0;
    return SizedBox(
      height: 200,
      child: Card(
        color: const Color.fromARGB(255, 43, 43, 43),
        margin: const EdgeInsets.all(10.0),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              match.fixture.formattedDate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                elapsedTime == null
                    ? const Text('-----', style: TextStyle(fontSize: 16))
                    : Text(
                        "${elapsedTime}'",
                        style: const TextStyle(fontSize: 14),
                      ),
                Text(
                  match.fixture.status.long,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    match.home.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Image.network(
                  match.home.logoUrl,
                  width: 36.0,
                ),
                Expanded(
                  child: Text(
                    "${homeGoal} - ${awayGoal}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Image.network(
                  match.away.logoUrl,
                  width: 36.0,
                ),
                Expanded(
                  child: Text(
                    match.away.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PredictResultScreen(),
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
                  elevation: 4.0,
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
