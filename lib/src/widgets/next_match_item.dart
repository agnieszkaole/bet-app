import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/match_id_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    int matchId = widget.match.fixture.id;
    var homeName = widget.match.home.name;
    var homeLogo = widget.match.home.logoUrl;
    var awayName = widget.match.away.name;
    var awayLogo = widget.match.away.logoUrl;
    var matchTime = widget.match.fixture.formattedDate;
    // var leagueName = widget.match.league.name;
    // var leagueNumber = widget.match.league.id;

    return GestureDetector(
      key: Key(matchId.toString()),
      onTap: () {
        String matchIdString = matchId.toString();
        Provider.of<MatchIdProvider>(context, listen: false).updateSelectedMatchId(matchIdString);
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          // color: Color.fromARGB(255, 41, 41, 41),
          // gradient: const LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Color.fromARGB(255, 0, 71, 33),
          //     Color.fromARGB(255, 1, 53, 26),
          //   ],
          // ),
          border: Border.all(
            width: 1,
            color: Color.fromARGB(255, 0, 71, 32),
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
      ),
    );
  }
}
