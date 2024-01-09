import 'package:bet_app/src/models/soccermodel.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PrevMatchItem extends StatelessWidget {
  final SoccerMatch match;
  const PrevMatchItem({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    var homeName = match.home.name;
    var homeGoal = match.goal.home;
    var homeLogo = match.home.logoUrl;
    var awayName = match.away.name;
    var awayGoal = match.goal.away;
    var awayLogo = match.away.logoUrl;
    var elapsedTime = match.fixture.status.elapsedTime;

    if (homeGoal == null) homeGoal = 0;
    if (awayGoal == null) awayGoal = 0;

    bool isSaved = true;

    return Container(
      decoration: const BoxDecoration(
          // border: Border(
          //   bottom: BorderSide(
          //     color: Color.fromARGB(255, 19, 19, 19),
          //     width: 3.0,
          //   ),
          // ),
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              match.fixture.formattedDate,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Column(
            //   children: [
            //     elapsedTime == null
            //         ? const Text('-----', style: TextStyle(fontSize: 16))
            //         : Text(
            //             "${elapsedTime}'",
            //             style: const TextStyle(fontSize: 14),
            //           ),
            //     Text(
            //       match.fixture.status.long,
            //       style: TextStyle(fontSize: 14),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    homeName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: homeLogo,
                    fadeInDuration: Duration(milliseconds: 50),
                    // placeholder: (context, url) =>
                    //     const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 36.0,
                    height: 36.0,
                  ),

                  //  Image.network(
                  //   homeLogo,
                  //   width: 36.0,
                  // height: 36.0,
                  // ),
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
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: awayLogo,
                    // placeholder: (context, url) =>
                    //     const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 36.0,
                    // height: 36.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    awayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 43, 43, 43),
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}
