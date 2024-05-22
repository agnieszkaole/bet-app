import 'package:bet_app/src/models/soccermodel.dart';

import 'package:bet_app/src/widgets/predict_result.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupMatchItem extends StatefulWidget {
  GroupMatchItem({
    required this.match,
    super.key,
    required this.isMatchAdded,
    required this.groupId,
    required this.selectedLeagueNumber,
  });
  final SoccerMatch match;
  final bool isMatchAdded;
  final String? groupId;
  final String? selectedLeagueNumber;
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
    var leagueName = widget.match.league.name;
    var leagueRound = widget.match.league.round;
    var leagueNumber = widget.match.league.id;
    var matchTime = widget.match.fixture.formattedDate;
    var matchTimeDate = widget.match.fixture.date;

    DateTime matchDateTime = DateTime.parse(matchTimeDate);
    // String formattedMatchTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(matchDateTime);
    // String currentFormattedTime = DateFormat("dd.MM.yyyy - HH:mm").format(DateTime.now());
    Duration timeDifference = matchDateTime.difference(DateTime.now());
    bool isWithinXHours = timeDifference.inMinutes <= 0;
    // final provider = Provider.of<PredictedMatchProvider>(context, listen: false);
    // bool isMatchAdded = provider.isMatchAdded(matchId);
    // print(widget.isMatchAdded);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(70, 49, 49, 49),
        border: Border.all(
          width: .8,
          color: const Color.fromARGB(192, 22, 124, 36),
        ),
      ),
      child: Stack(children: [
        isWithinXHours || widget.isMatchAdded
            ? Positioned(
                right: 20.0,
                bottom: 10.0,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Notice"),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Betting is unavailable.",
                              //   style: TextStyle(fontSize: 18),
                              // ),
                              // SizedBox(height: 20),
                              Text(
                                "The match has already started, finished or you have already placed a bet on this match.",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Check the "Your bets" tab. ',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 2, 126, 6),
                                  foregroundColor: const Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 28,
                    color: Color.fromARGB(255, 255, 242, 63),
                  ),
                ),
              )
            : const SizedBox(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              matchTime.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 5),
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
                const SizedBox(
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
              height: 40,
              width: 180,
              child: !isWithinXHours && !widget.isMatchAdded
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
                              groupId: widget.groupId,
                              selectedLeagueNumber: widget.selectedLeagueNumber),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 3.0,
                      ),
                      child: const Text('Predict the result'),
                    )
                  : OutlinedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        disabledForegroundColor: const Color.fromARGB(193, 206, 206, 206),
                        elevation: 3.0,
                      ),
                      child: const Text('Predict the result'),
                    ),
            ),
          ],
        ),
      ]),
    );
  }
}
