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
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 0, 94, 42),
            Color.fromARGB(255, 0, 44, 20),
            // Color.fromARGB(255, 44, 44, 44),
            // Color.fromARGB(255, 39, 39, 39),
          ],
        ),
        // border: Border.all(
        //   width: 0.5,
        //   color: Color.fromARGB(147, 167, 167, 167),
        // ),
        // color: Color.fromARGB(255, 41, 41, 41),
        // border: Border.all(
        //   width: 1,
        //   color: Color.fromARGB(148, 40, 122, 43),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
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
                            fontSize: 12.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.teams.home.logo,
                            fadeInDuration: const Duration(milliseconds: 50),
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            width: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 15,
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "vs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
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
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.teams.away.logo,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            width: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Column(
            children: [
              Text(
                'Percent',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Container(
                width: 200,
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
          SizedBox(height: 10),
          Column(
            children: [
              Text(
                'Poisson distribution',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Container(
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        // Text(
                        //   'home',
                        //   textAlign: TextAlign.center,
                        // ),
                        Text(
                          widget.comparison.home,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      'vs',
                    ),
                    Column(
                      children: [
                        // Text(
                        //   'away',
                        //   textAlign: TextAlign.center,
                        // ),
                        Text(
                          widget.comparison.away,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Column(
            children: [
              Text(
                'Advice',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                widget.predictions.advice,
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );
  }
}
