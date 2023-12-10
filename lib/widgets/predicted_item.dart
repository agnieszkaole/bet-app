import 'package:bet_app/models/soccermodel.dart';
import 'package:flutter/material.dart';

class PredictedItem extends StatelessWidget {
  const PredictedItem({super.key});

  @override
  Widget build(BuildContext context) {
    // var homeName = match.home.name;
    // var homeGoal = match.goal.home;
    // var homeLogo = match.home.logoUrl;
    // var awayName = match.away.name;
    // var awayGoal = match.goal.away;
    // var awayLogo = match.away.logoUrl;

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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      // homeName,
                      "erwer",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(
                      // homeLogo,
                      "erter",
                      // width: 36.0,
                      // height: 36.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      // "${homeGoal} - ${awayGoal}",
                      "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(
                      // awayLogo,
                      "rtyrty",
                      width: 36.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      // awayName,
                      "utyutyu",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              // Container(
              //     height: 40,
              //     margin: EdgeInsets.all(10),
              //     child: ElevatedButton(
              //       onPressed: () {},
              //       style: ElevatedButton.styleFrom(
              //         foregroundColor: Colors.white,
              //         backgroundColor:
              //             const Color.fromARGB(255, 40, 122, 43),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(25),
              //         ),
              //         elevation: 4.0,
              //       ),
              //       child: const Text('Wytypuj wynik'),
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
