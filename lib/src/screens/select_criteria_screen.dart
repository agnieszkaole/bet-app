import 'dart:async';
import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/screens/user_groups.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/match_prediction.dart';
import 'package:bet_app/src/widgets/match_prediction_list.dart';
import 'package:bet_app/src/widgets/match_scheduled.dart';

import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:bet_app/src/widgets/prev_match_list.dart';
import 'package:bet_app/src/widgets/standings_list.dart';
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
  // bool? isAnonymous = true;
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
      // isAnonymous = user.isAnonymous;
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    width: 0.5,
                    color: Color.fromARGB(170, 62, 155, 19),
                  ),
                  // color: const Color.fromARGB(20, 0, 0, 0),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(120, 62, 155, 19),
                      Color.fromARGB(120, 31, 77, 10),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hello ${username != null ? '$username' : ''}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '   👋',
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Let\'s bet with friends!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // border: Border.all(width: 0.4, color: Color.fromARGB(60, 206, 206, 206)),
                  // gradient: const LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Color.fromARGB(100, 39, 39, 39),
                  //     Color.fromARGB(100, 39, 39, 39),
                  //   ],
                  // )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top leagues',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: leagueNames.length,
                        itemBuilder: (context, index) {
                          var league = leagueNames[index];
                          return GestureDetector(
                            // key: Key(league["number"].toString()),
                            child: Container(
                                // width: 220,
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                        ? Border.all(width: 0.2, color: Color.fromARGB(255, 0, 168, 76))
                                        : Border.all(width: 0.8, color: Color.fromARGB(255, 0, 100, 45)),
                                    gradient: isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                        ? const LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color.fromARGB(220, 62, 155, 19),
                                              Color.fromARGB(220, 31, 77, 10),
                                            ],
                                          )
                                        : const LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color.fromARGB(150, 39, 39, 39),
                                              Color.fromARGB(150, 39, 39, 39),
                                            ],
                                          )),
                                child: Center(
                                  child: Text(
                                    league["name"],
                                    style: TextStyle(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        fontWeight:
                                            isSelectedLeague && selectedLeagueNumber == league['number'].toString()
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
                      ),
                    ),
                  ],
                ),
              ),

              // const Divider(
              //   height: 40,
              //   color: Color.fromARGB(255, 99, 99, 99),
              //   thickness: 1,
              // ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // border: Border.all(width: 0.4, color: Color.fromARGB(60, 206, 206, 206)),
                  // gradient: const LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Color.fromARGB(100, 39, 39, 39),
                  //     Color.fromARGB(100, 39, 39, 39),
                  //   ],
                  // )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'League overview',
                    //   // 'Quick overview | Next matches',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     // fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const Text(
                      'Overview',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Upcoming matches',
                      // ' | Next matches',
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    NextMatchList(
                      leagueNumber: selectedLeagueNumber,
                      isSelectedLeague: isSelectedLeague,
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Latest Scores',
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    PrevMatchList(
                      leagueNumber: selectedLeagueNumber,
                      isSelectedLeague: isSelectedLeague,
                    ),
                    // const Text(
                    //   'Standings',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     // fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // StandingsList(
                    //   leagueNumber: selectedLeagueNumber,
                    // ),
                    // SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
