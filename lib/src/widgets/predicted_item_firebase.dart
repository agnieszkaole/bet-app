import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/widgets/predicted_result_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictedItemFirebase extends StatefulWidget {
  PredictedItemFirebase({
    required this.data,
    super.key,
  });

  late Map<String, dynamic> data;

  @override
  State<PredictedItemFirebase> createState() => _PredictedItemFirebaseState();
}

class _PredictedItemFirebaseState extends State<PredictedItemFirebase> {
  bool isNewMatch = true;

  @override
  Widget build(BuildContext context) {
    String homeName = widget.data['homeName'] ?? '';
    String awayName = widget.data['awayName'] ?? '';
    String homeLogo = widget.data['homeLogo'] ?? '';
    String awayLogo = widget.data['awayLogo'] ?? '';
    int homeGoal = widget.data['homeGoal'] ?? 0;
    int awayGoal = widget.data['awayGoal'] ?? 0;
    // String leagueName = widget.data['leagueName'] ?? '';
    String matchTime = widget.data['matchTime'] ?? '';
    int matchId = widget.data['matchId'] ?? 0;

    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          // color: Color.fromARGB(82, 40, 122, 43),
          border: Border.all(width: 1, color: Color.fromARGB(255, 70, 70, 70)),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    matchTime,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 30.0,
                      // height: 30.0,
                    ),

                    //  Image.network(
                    //   homeLogo,
                    //   width: 36.0,
                    // height: 36.0,
                    // ),
                  ),
                  Expanded(
                    child: Text(
                      "$homeGoal - $awayGoal",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CachedNetworkImage(
                      imageUrl: awayLogo,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 30.0,
                      // height: 30.0,
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
            ],
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            child: SizedBox(
              width: 35,
              height: 35,
              child: (DateTime.now().hour > 24)
                  // true
                  ? null
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                          width: 1,
                          color: Color.fromARGB(90, 66, 201, 70),
                        ),
                        // side: BorderSide.none,
                        foregroundColor:
                            // const Color.fromARGB(255, 176, 206, 177),
                            Color.fromARGB(255, 66, 201, 70),
                      ),
                      // onPressed: () {},
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PredictedResultEdit(
                            teamHomeName: homeName,
                            teamAwayName: awayName,
                            teamHomeLogo: homeLogo,
                            teamAwayLogo: awayLogo,
                            matchId: matchId,
                          ),
                        ));
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit_note_rounded,
                          size: 24,
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
