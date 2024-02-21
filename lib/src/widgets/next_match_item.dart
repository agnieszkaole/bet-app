import 'package:bet_app/src/models/soccermodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NextMatchItem extends StatefulWidget {
  const NextMatchItem({required this.match, super.key});
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

    int matchId = widget.match.fixture.id;
    var homeName = widget.match.home.name;
    var homeLogo = widget.match.home.logoUrl;
    var awayName = widget.match.away.name;
    var awayLogo = widget.match.away.logoUrl;
    var matchTime = widget.match.fixture.formattedDate;
    var leagueName = widget.match.league.name;
    var leagueRound = widget.match.league.round;
    var leagueNumber = widget.match.league.id;

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: Color.fromARGB(200, 40, 122, 43),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(148, 40, 122, 43),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            Text(
              matchTime.toString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            // Text(
            //   leagueRound.toString(),
            //   style: const TextStyle(fontSize: 12),
            //   textAlign: TextAlign.center,
            // ),
          ]),
          const SizedBox(height: 10),
          Row(
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
                      child: Padding(
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
                      child: Padding(
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
    );
  }
}
