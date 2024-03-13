import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MatchPredictionItem extends StatefulWidget {
  const MatchPredictionItem({super.key, required this.predictions, required this.teams, required this.comparison});

  final Prediction predictions;
  final TeamsData teams;
  final Comparison comparison;

  @override
  State<MatchPredictionItem> createState() => _MatchPredictionItemState();
}

class _MatchPredictionItemState extends State<MatchPredictionItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text(
              'Predictions',
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              height: 220,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 41, 41, 41),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 0, 49, 22),
                    Color.fromARGB(255, 0, 70, 30),
                  ],
                ),
                // border: Border.all(
                //   width: 0.5,
                //   color: Color.fromARGB(146, 99, 99, 99),
                // ),
                // color: Color.fromARGB(255, 41, 41, 41),
                border: Border.all(
                  width: 1,
                  color: Color.fromARGB(255, 47, 56, 49),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                widget.teams.home.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.teams.home.logo,
                                  fadeInDuration: const Duration(milliseconds: 50),
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 12,
                        margin: EdgeInsets.only(top: 60),
                        child: Text(
                          "vs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                widget.teams.away.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.teams.away.logo,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   'Percent',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),

                      Container(
                        width: 260,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                // Text('home'),
                                Text(widget.predictions.percent.home),
                              ],
                            ),
                            Column(
                              children: [
                                // Text('draw'),
                                Text(widget.predictions.percent.draw),
                              ],
                            ),
                            Column(
                              children: [
                                // Text('away'),
                                Text(widget.predictions.percent.away),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.predictions.advice,
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 15),
                ],
              ),
            )
          ]),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Top scorers',
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  height: 220,
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 0, 49, 22),
                        Color.fromARGB(255, 0, 70, 30),
                      ],
                    ),
                    border: Border.all(
                      width: 1,
                      color: Color.fromARGB(255, 47, 56, 49),
                    ),
                    // color: Color.fromARGB(255, 41, 41, 41),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CachedNetworkImage(
                              imageUrl: 'https://media.api-sports.io/football/players/104797.png',
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fit: BoxFit.fill,
                              // width: 30,
                            ),
                          ),
                          Text(
                            'Erik Expósito',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          // Text(
                          //   'name',
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                      ),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Team: Slask Wroclaw',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Total goals: 14',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Total shots: 41',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Shots on: 29',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Games played: 22',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
