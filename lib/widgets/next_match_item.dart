import 'package:bet_app/models/soccermodel.dart';
import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:bet_app/widgets/predict_result.dart';
import 'package:bet_app/widgets/predicted_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextMatchItem extends StatefulWidget {
  NextMatchItem({required this.match, super.key});
  final SoccerMatch match;
  bool isNewMatch = true;

  @override
  State<NextMatchItem> createState() => _NextMatchItemState();
}

class _NextMatchItemState extends State<NextMatchItem>
    with AutomaticKeepAliveClientMixin<NextMatchItem> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final predictedMatchList =
        context.watch<PredictedMatchProvider>().predictedMatchList;
    final predictedMatch =
        predictedMatchList.map((predictedMatch) => predictedMatch);
    print(predictedMatch);

    int matchId = widget.match.fixture.id;
    var homeName = widget.match.home.name;
    var homeLogo = widget.match.home.logoUrl;
    var awayName = widget.match.away.name;
    var awayLogo = widget.match.away.logoUrl;
    var matchTime = widget.match.fixture.formattedDate;

    return Container(
      child: SizedBox(
        // height: 220,
        child: Card(
          // color: const Color.fromARGB(255, 43, 43, 43),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  matchTime,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 36.0,
                        // height: 36.0,
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
                  // height: 130,
                  margin: const EdgeInsets.only(top: 15),
                  child: widget.isNewMatch
                      ? ElevatedButton(
                          onPressed: () async {
                            final newValue = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => PredictResult(
                                teamHomeName: homeName,
                                teamAwayName: awayName,
                                teamHomeLogo: homeLogo,
                                teamAwayLogo: awayLogo,
                                matchTime: matchTime,
                                matchId: matchId,
                                isNewMatch: widget.isNewMatch,
                              ),
                            ));
                            setState(() {
                              widget.isNewMatch = newValue;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 40, 122, 43),
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
                            // disabledBackgroundColor:
                            //     const Color.fromARGB(193, 77, 77, 77),
                            disabledForegroundColor:
                                Color.fromARGB(193, 206, 206, 206),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(25),
                            // ),
                            elevation: 3.0,
                          ),
                          child: const Text('Dodano do zakładów'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
