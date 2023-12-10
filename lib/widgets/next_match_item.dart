import 'package:bet_app/models/soccermodel.dart';
import 'package:bet_app/widgets/predict_result.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NextMatchItem extends StatelessWidget {
  final SoccerMatch match;
  const NextMatchItem({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    var homeName = match.home.name;
    // var homeGoal = match.goal.home;
    var homeLogo = match.home.logoUrl;
    var awayName = match.away.name;
    // var awayGoal = match.goal.away;
    var awayLogo = match.away.logoUrl;

    // if (homeGoal == null) homeGoal = 0;
    // if (awayGoal == null) awayGoal = 0;

    bool isSaved = true;

    return SizedBox(
      // height: 220,
      child: Card(
        // color: const Color.fromARGB(255, 43, 43, 43),
        margin: const EdgeInsets.all(10.0),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
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
                    child: const Text(
                      "vs",
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
              Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 20),
                  child: isSaved
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PredictResult(
                                  teamHomeName: homeName,
                                  teamAwayName: awayName,
                                  teamHomeLogo: homeLogo,
                                  teamAwayLogo: awayLogo,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 40, 122, 43),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 4.0,
                          ),
                          child: const Text('Wytypuj wynik'),
                        )
                      : OutlinedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            // disabledBackgroundColor:
                            //     const Color.fromARGB(193, 77, 77, 77),
                            disabledForegroundColor:
                                Color.fromARGB(193, 206, 206, 206),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(25),
                            // ),
                            elevation: 3.0,
                          ),
                          child: const Text(
                              'Dodano! Szukaj w zakładce Twoje zakłady'),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
