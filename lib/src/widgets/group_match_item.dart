import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/widgets/match_prediction_list.dart';
import 'package:bet_app/src/widgets/predict_result.dart';
import 'package:bet_app/src/widgets/predicted_item_firebase.dart';
import 'package:bet_app/src/widgets/predicted_matches_firebase.dart';
import 'package:bet_app/src/widgets/predicted_matches_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/predicted_match_provider.dart';

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
  User? user = FirebaseAuth.instance.currentUser;

  // Future<bool> _checkIfMatchPredicted(int matchId) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return false;

  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('predictions')
  //       .where('matchId', isEqualTo: matchId)
  //       .where('groupId', isEqualTo: widget.groupId)
  //       .get();

  //   return querySnapshot.docs.isNotEmpty;
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final predictedMatchProvider = Provider.of<PredictedMatchProvider>(context, listen: false).predictedMatchList;

    // print(predictedMatchProvider);
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

    // final getGoals = Provider.of<PredictedMatchProvider>(context, listen: false).getMatchGoals(matchId, widget.groupId);
    // int? teamHomeGoal = getGoals['teamHomeGoal'];
    // int? teamAwayGoal = getGoals['teamAwayGoal'];
    // print(teamHomeGoal);

    DateTime matchDateTime = DateTime.parse(matchTimeDate);
    Duration timeDifference = matchDateTime.difference(DateTime.now());
    bool isWithinXHours = timeDifference.inMinutes <= 0;

    return Container(
      height: widget.isMatchAdded ? 215 : null,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Color.fromARGB(70, 49, 49, 49),
        border: Border.all(
          width: .5,
          color: Color.fromARGB(192, 80, 80, 80),
        ),
      ),
      child: Stack(
        children: [
          // isWithinXHours || widget.isMatchAdded
          isWithinXHours
              ? Positioned(
                  right: 20.0,
                  top: 10.0,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierColor: Color.fromARGB(167, 9, 11, 29),
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColors.green),
                                borderRadius: BorderRadius.all(Radius.circular(25.0))),
                            // title: const Text("Notice"),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  'You cannot bet, the match has alread been started.',
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
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              !isWithinXHours && !widget.isMatchAdded
                  ? Container(
                      height: 40,
                      width: 180,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PredictResult(
                              homeName: homeName,
                              awayName: awayName,
                              homeLogo: homeLogo,
                              awayLogo: awayLogo,
                              matchTime: matchTime.toString(),
                              matchId: matchId,
                              leagueName: leagueName,
                              leagueNumber: leagueNumber,
                              groupId: widget.groupId,
                              selectedLeagueNumber: widget.selectedLeagueNumber,
                            ),
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
                      ),
                    )
                  : const SizedBox(),
              // FutureBuilder(
              //   future: _checkIfMatchPredicted(matchId),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CircularProgressIndicator();
              //     }
              //     if (snapshot.hasError) {
              //       return const Text('Error checking prediction status');
              //     }
              //     bool isPredicted = snapshot.data as bool;
              //     return isPredicted
              //         // ? PredictedItemFirebase(
              //         //     data: snapshot.data,
              //         //     docId: snapshot.data!.docs.first.id,
              //         //   )
              //         ? PredictedMatchesFirebase(leagueNumber: leagueNumber, matchId: matchId, groupId: widget.groupId)
              //         : const SizedBox();
              //   },
              // ),

              widget.isMatchAdded
                  ? PredictedMatchesFirebase(leagueNumber: leagueNumber, matchId: matchId, groupId: widget.groupId)
                  : const SizedBox(),

              //     PredictedMatchesPreview(
              //         leagueNumber: leagueNumber,
              //         matchId: matchId,
              //         groupId: widget.groupId,
              //       ),

              // if (isWithinXHours)
              //   Container(
              //     height: 40,
              //     width: 180,
              //     margin: EdgeInsets.all(10),
              //     child: OutlinedButton(
              //       onPressed: null,
              //       style: OutlinedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(25),
              //         ),
              //         elevation: 3.0,
              //       ),
              //       child: const Text('Predict the result'),
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
