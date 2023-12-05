import 'package:bet_app/models/soccermodel.dart';
import 'package:flutter/material.dart';

Widget matchTile(SoccerMatch match) {
  var homeGoal = match.goal.home;
  var awayGoal = match.goal.away;
  if (homeGoal == null) homeGoal = 0;
  if (awayGoal == null) awayGoal = 0;

  return Card(
    color: const Color.fromARGB(255, 43, 43, 43),
    margin: const EdgeInsets.all(10.0),
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 2,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(match.fixture.date),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            '${match.fixture.status.elapsedTime}\'',
            style: const TextStyle(fontSize: 20),
          ),
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
                  fontSize: 16.0,
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
      ],
    ),
  );
}
