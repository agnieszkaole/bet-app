import 'package:bet_app/src/models/soccermodel.dart';

import 'package:bet_app/src/widgets/predict_result.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupMatchItem extends StatefulWidget {
  const GroupMatchItem({required this.match, super.key});
  final SoccerMatch match;

  @override
  State<GroupMatchItem> createState() => _GroupMatchItemState();
}

class _GroupMatchItemState extends State<GroupMatchItem> with AutomaticKeepAliveClientMixin<GroupMatchItem> {
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        // color: Color.fromARGB(200, 40, 122, 43),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(200, 40, 122, 43),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            matchTime.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 5),
          Text(
            leagueRound.toString(),
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Container(
                padding: const EdgeInsets.all(5.0),
                child: CachedNetworkImage(
                  imageUrl: homeLogo,
                  fadeInDuration: const Duration(milliseconds: 50),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 36.0,
                  height: 36.0,
                ),
              ),
              Container(
                width: 30,
                child: Text(
                  "vs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: CachedNetworkImage(
                  imageUrl: awayLogo,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 36.0,
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
          const SizedBox(height: 10),
          Container(
            height: 30,
            width: 160,
            child: (true)
                ? ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PredictResult(
                          homeName: homeName,
                          awayName: awayName,
                          homeLogo: homeLogo,
                          awayLogo: awayLogo,
                          matchTime: matchTime.toString(),
                          matchId: matchId,
                          match: widget.match,
                          leagueName: leagueName,
                          leagueNumber: leagueNumber,
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4.0,
                    ),
                    child: const Text('Predict the result'),
                  )
                : OutlinedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Color.fromARGB(193, 206, 206, 206),
                      elevation: 3.0,
                    ),
                    child: const Text('Dodano do zakładki Twoje Typy'),
                  ),
          ),
        ],
      ),
    );
  }
}
