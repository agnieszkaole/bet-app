import 'dart:async';
import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/match_prediction.dart';
import 'package:bet_app/src/widgets/match_prediction_list.dart';

import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

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
    String? initialUsername = await UserData().getUsernameFromFirebase();

    setState(() {
      username = initialUsername;
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        UserData().getUsernameFromFirebase().then((newUsername) {
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
    // final ScrollController _scrollController = ScrollController();

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
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
              ),
              const Divider(
                height: 40,
                color: Color.fromARGB(255, 40, 122, 43),
                thickness: 1.5,
              ),
              // Text(
              //   'Select a league that interests you',
              //   style: TextStyle(
              //     fontSize: 18,
              //     // fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (final league in leagueNames)
                                Center(
                                  child: GestureDetector(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        margin: const EdgeInsets.symmetric(horizontal: 6),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border:
                                                isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                                    ? Border.all(width: 1.2, color: Color.fromARGB(255, 219, 219, 219))
                                                    : Border.all(width: 0.5, color: Color.fromARGB(255, 14, 110, 14)),
                                            gradient:
                                                isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                                    ? const LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: [
                                                          Color.fromARGB(169, 0, 199, 90),
                                                          Color.fromARGB(209, 0, 138, 62),
                                                        ],
                                                      )
                                                    : const LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: [
                                                          Color.fromARGB(146, 0, 199, 90),
                                                          Color.fromARGB(162, 0, 138, 62),
                                                        ],
                                                      )),
                                        child: Text(league["name"],
                                            style: TextStyle(
                                                fontWeight: isSelectedLeague &&
                                                        selectedLeagueNumber == league['number'].toString()
                                                    ? FontWeight.bold
                                                    : FontWeight.normal))),
                                    onTap: () {
                                      setState(() {
                                        selectedLeagueNumber = league['number'].toString();
                                        isSelectedLeague = true;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 40,
                    color: Color.fromARGB(255, 40, 122, 43),
                    thickness: 1.5,
                  ),
                  NextMatchList(leagueNumber: selectedLeagueNumber, isSelectedLeague: isSelectedLeague),
                  const SizedBox(height: 10),
                  MatchPredictionList(leagueNumber: selectedLeagueNumber, matchId: '198772'),
                  const SizedBox(height: 20),
                ],
              ),
            ]),
      ),
    ));
  }
}
