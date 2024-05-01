import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/match_id_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    int matchId = widget.match.fixture.id;
    var homeName = widget.match.home.name;
    var homeLogo = widget.match.home.logoUrl;
    var homeGoal = widget.match.goal.home;
    var awayName = widget.match.away.name;
    var awayLogo = widget.match.away.logoUrl;
    var awayGoal = widget.match.goal.away;
    var matchTime = widget.match.fixture.formattedDate;
    var leagueRound = widget.match.league.round;
    // var leagueName = widget.match.league.name;
    // var leagueNumber = widget.match.league.id;

    return Container(
      margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        // color: Color.fromARGB(195, 8, 119, 4),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            // Color.fromARGB(200, 31, 77, 10),
            Color.fromARGB(197, 31, 31, 31),
            Color.fromARGB(200, 62, 155, 19),
          ],
        ),
        border: Border.all(
          width: .5,
          color: Color.fromARGB(255, 116, 116, 116),
        ),
        // image: DecorationImage(
        //   image: AssetImage('./assets/images/lawn-5007569_19201.jpg'),
        //   fit: BoxFit.cover,
        //   colorFilter: ColorFilter.mode(
        //     Color.fromARGB(70, 29, 29, 29),
        //     BlendMode.srcATop,
        //   ),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 120,
            child: Column(children: [
              Text(
                matchTime.toString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                leagueRound,
                style: const TextStyle(fontSize: 12),
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
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      homeGoal.toString(),
                    ),
                  ),
                ],
              ),
              Container(
                width: 30,
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
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 10,
                    margin: EdgeInsets.only(top: 20),
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
        ],
      ),
    );
  }
}
