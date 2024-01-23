import 'package:bet_app/src/models/soccermodel.dart';

import 'package:bet_app/src/widgets/predict_result.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NextMatchItem extends StatefulWidget {
  const NextMatchItem({required this.match, super.key});
  final SoccerMatch match;

  @override
  State<NextMatchItem> createState() => _NextMatchItemState();
}

class _NextMatchItemState extends State<NextMatchItem>
    with AutomaticKeepAliveClientMixin<NextMatchItem> {
  @override
  bool get wantKeepAlive => true;
  bool isNewMatch = true;
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
      decoration: BoxDecoration(
        // color: Color.fromARGB(200, 40, 122, 43),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(200, 40, 122, 43),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            matchTime,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            leagueName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: CachedNetworkImage(
                  imageUrl: homeLogo,
                  fadeInDuration: const Duration(milliseconds: 50),
                  // placeholder: (context, url) =>
                  //     const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 36.0,
                  height: 36.0,
                ),
                //  Image.network(
                //   homeLogo,
                //   width: 36.0,
                // height: 36.0,
                // ),
              ),
              const Expanded(
                child: Text(
                  "vs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: CachedNetworkImage(
                  imageUrl: awayLogo,
                  // placeholder: (context, url) =>
                  //     const CircularProgressIndicator(),
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
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: (isNewMatch)
                ? ElevatedButton(
                    onPressed: () async {
                      final newValueIsNewMatch =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PredictResult(
                          homeName: homeName,
                          awayName: awayName,
                          homeLogo: homeLogo,
                          awayLogo: awayLogo,
                          matchTime: matchTime,
                          matchId: matchId,
                          isNewMatch: isNewMatch,
                          match: widget.match,
                          leagueName: leagueName,
                        ),
                      ));

                      setState(() {
                        isNewMatch = newValueIsNewMatch;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4.0,
                    ),
                    child: const Text('Wytypuj wynik'),
                  )
                : OutlinedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor:
                          Color.fromARGB(193, 206, 206, 206),
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
