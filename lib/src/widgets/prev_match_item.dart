import 'package:bet_app/src/models/soccermodel.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PrevMatchItem extends StatefulWidget {
  const PrevMatchItem({
    super.key,
    required this.match,
  });
  final SoccerMatch match;

  @override
  State<PrevMatchItem> createState() => _PrevMatchItemState();
}

class _PrevMatchItemState extends State<PrevMatchItem> with AutomaticKeepAliveClientMixin<PrevMatchItem> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // int matchId = widget.match.fixture.id;
    var homeName = widget.match.home.name;
    var homeLogo = widget.match.home.logoUrl;
    var homeGoal = widget.match.goal.home;
    var awayName = widget.match.away.name;
    var awayLogo = widget.match.away.logoUrl;
    var awayGoal = widget.match.goal.away;
    var matchTime = widget.match.fixture.formattedDate;
    // var leagueRound = widget.match.league.round;
    // var leagueName = widget.match.league.name;
    // var leagueNumber = widget.match.league.id;

    return Container(
      margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120,
            child: Column(children: [
              Text(
                matchTime.toString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 80,
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            homeName,
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
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: CachedNetworkImage(
                              imageUrl: homeLogo,
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
                    width: 10,
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      homeGoal.toString(),
                    ),
                  ),
                ],
              ),
              Container(
                width: 30,
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  "vs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 10,
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      awayGoal.toString(),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            awayName,
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
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: CachedNetworkImage(
                              imageUrl: awayLogo,
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
            ],
          ),
          const Divider(
            height: 0.5,
            thickness: 0.5,
            color: Color.fromARGB(255, 0, 117, 10),
          )
        ],
      ),
    );
  }
}
