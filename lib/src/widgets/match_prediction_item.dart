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
    print(widget.prediction.percent.home);
    print(widget.prediction.percent.draw);
    print(widget.prediction.percent.away);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          // constraints: BoxConstraints(maxWidth: 300),
          // height: 150, // width: MediaQuery.of(context).size.width / 2,

          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("./assets/images/little-1506570_192011.png"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              widget.teams.home.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.teams.home.logo,
                                fadeInDuration: const Duration(milliseconds: 50),
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                width: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    margin: EdgeInsets.only(top: 60),
                    child: Text(
                      "vs",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              widget.teams.away.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.teams.away.logo,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                width: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

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
