import 'package:bet_app/src/models/soccermodel.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NextMatchItem extends StatefulWidget {
  const NextMatchItem({
    super.key,
    required this.match,
  });
  final SoccerMatch match;

  @override
  State<NextMatchItem> createState() => _NextMatchItemState();
}

class _NextMatchItemState extends State<NextMatchItem> with AutomaticKeepAliveClientMixin<NextMatchItem> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // int matchId = widget.match.fixture.id;
    var homeName = widget.match.home.name;
    var homeLogo = widget.match.home.logoUrl;
    var awayName = widget.match.away.name;
    var awayLogo = widget.match.away.logoUrl;
    var matchTime = widget.match.fixture.formattedDate;
    var leagueRound = widget.match.league.round;
    // var leagueName = widget.match.league.name;
    // var leagueNumber = widget.match.league.id;

    return Container(
      // height: ,
      margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 15),
      // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120,
            child: Column(
              children: [
                Text(
                  matchTime.toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                width: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                    SizedBox(width: 15),
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
                width: 15,
                child: const Text(
                  "vs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    SizedBox(width: 15),
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
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: Color.fromARGB(255, 0, 117, 10),
          )
        ],
      ),
    );
  }
}
