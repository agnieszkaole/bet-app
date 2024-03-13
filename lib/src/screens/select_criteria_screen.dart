import 'dart:async';
import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/match_prediction.dart';
import 'package:bet_app/src/widgets/match_prediction_list.dart';

import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SelectCriteriaScreen extends StatefulWidget {
  const SelectCriteriaScreen({
    super.key,
  });

  @override
  State<SelectCriteriaScreen> createState() => _SelectCriteriaScreenState();
}

class _SelectCriteriaScreenState extends State<SelectCriteriaScreen> {
  // String? selectedLeagueNumber;
  // String? selectedLeagueName;
  User? user = Auth().currentUser;
  bool? isAnonymous = true;
  bool? isUsernameModify = false;
  String? username;
  String? selectedLeagueNumber;
  bool isSelectedLeague = false;

  @override
  void initState() {
    super.initState();
    initUserDetails();
    selectedLeagueNumber = '106';
    isSelectedLeague = true;
  }

  Future<void> initUserDetails() async {
    User? user = Auth().currentUser;
    if (user != null) {
      isAnonymous = user.isAnonymous;
    }
    String? initialUsername = await UserData().getUserDataFromFirebase();

    setState(() {
      username = initialUsername;
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        UserData().getUserDataFromFirebase().then((newUsername) {
          setState(() {
            username = newUsername;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
    // String? matchId;
    // nextMatchesList.forEach((match) {
    //   matchId = match.fixture.id.toString();
    // });

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello ${username != null ? '$username' : ''}',
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Let\'s start betting with your friends. 🖐',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          const Divider(
            height: 40,
            color: Color.fromARGB(255, 99, 99, 99),
            thickness: 1,
          ),
          // Text(
          //   'Select a league that interests you',
          //   style: TextStyle(
          //     fontSize: 18,
          //     // fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: CarouselSlider.builder(
              itemCount: leagueNames.length,
              itemBuilder: (context, index, _) {
                var league = leagueNames[index];
                return GestureDetector(
                  // key: Key(league["number"].toString()),

                  child: Container(
                      width: 220,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                              ? Border.all(width: 0.8, color: Color.fromARGB(255, 219, 219, 219))
                              : Border.all(width: 0.8, color: Color.fromARGB(255, 0, 100, 45)),
                          gradient: isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                              ? const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromARGB(255, 1, 141, 64),
                                    Color.fromARGB(255, 0, 100, 45),
                                  ],
                                )
                              : const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromARGB(255, 1, 141, 64),
                                    Color.fromARGB(255, 0, 100, 45),
                                  ],
                                )),
                      child: Center(
                        child: Text(
                          league["name"],
                          style: TextStyle(
                              fontWeight: isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  onTap: () {
                    setState(() {
                      selectedLeagueNumber = league['number'].toString();
                      isSelectedLeague = true;
                    });
                  },
                );
              },
              options: CarouselOptions(
                height: 380.0,
                initialPage: 1,
                enlargeCenterPage: true,
                // autoPlay: true,
                // enlargeFactor: 1.5,
                // aspectRatio: 16 / 9,

                // autoPlayCurve: Curves.fastOutSlowIn,
                // enableInfiniteScroll: false,
                // autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.5,
              ),
            ),
          ),
          // const Divider(
          //   height: 40,
          //   color: Color.fromARGB(255, 99, 99, 99),
          //   thickness: 1,
          // ),
          SizedBox(height: 20),
          const Text(
            'Upcoming matches',
            style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
          NextMatchList(
            leagueNumber: selectedLeagueNumber,
            isSelectedLeague: isSelectedLeague,
          ),
          const SizedBox(height: 10),

          // MatchPredictionList(leagueNumber: selectedLeagueNumber, matchId: '1036013'),
          MatchPredictionList(
            leagueNumber: selectedLeagueNumber,
          ),
          const SizedBox(height: 20),
        ]),
      ),
    ));
  }
}
