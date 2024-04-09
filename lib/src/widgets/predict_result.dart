// import 'dart:convert';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
// import 'package:bet_app/src/screens/predicted_screen.dart';
import 'package:bet_app/src/services/auth.dart';
// import 'package:bet_app/src/widgets/predicted_item_local.dart';
// import 'package:bet_app/src/widgets/predicted_result_edith.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PredictResult extends StatefulWidget {
  const PredictResult({
    super.key,
    required this.homeName,
    required this.awayName,
    required this.homeLogo,
    required this.awayLogo,
    required this.matchTime,
    required this.matchId,
    required this.match,
    required this.leagueName,
    required this.leagueNumber,
  });

  final String homeName;
  final String awayName;
  final String homeLogo;
  final String awayLogo;
  final String matchTime;
  final int matchId;
  final SoccerMatch match;
  final String leagueName;
  final int? leagueNumber;
  @override
  State<PredictResult> createState() => _PredictResultState();
}

class _PredictResultState extends State<PredictResult> {
  int? _resultHome;
  int? _resultAway;

  final _formKey = GlobalKey<FormState>();
  User? user = Auth().currentUser;
  bool isAnonymous = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isAnonymous = user!.isAnonymous;
    });
  }

  Future<void> addPredictedMatch(
    String homeName,
    String awayName,
    String homeLogo,
    String awayLogo,
    int? homeGoal,
    int? awayGoal,
    String leagueName,
    int? leagueNumber,
    int matchId,
    String matchTime,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not authenticated');
        return;
      }

      // QuerySnapshot<Map<String, dynamic>> existingMatches =
      //     await FirebaseFirestore.instance
      //         .collection('users')
      //         .doc(user.uid)
      //         .collection('matches')
      //         .where('matchId', isEqualTo: matchId)
      //         .get();

      // if (existingMatches.docs.isNotEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Ten mecz jest już dodany!'),
      //       duration: Duration(milliseconds: 1500),
      //     ),
      //   );

      //   return;
      // }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('predictions').add({
        'homeName': homeName,
        'awayName': awayName,
        'homeLogo': homeLogo,
        'awayLogo': awayLogo,
        'homeGoal': homeGoal,
        'awayGoal': awayGoal,
        'leagueName': leagueName,
        'leagueNumber': leagueNumber,
        'matchId': matchId,
        'matchTime': matchTime,
      });

      print('Predicted match added to Firestore for the user');
    } catch (e) {
      print('Error adding predicted match: $e');
    }
  }

  void _savePredictResult() async {
    // final predictedMatchList =
    //     context.watch<PredictedMatchProvider>().predictedMatchList;
    // int? predictedMatchId;
    // for (var i = 0; i > predictedMatchList.length; i++) {
    //   predictedMatchId = predictedMatchList[i]['matchId'];
    // }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!context.mounted) {
        return;
      }
      // setState(() {
      //   isNewMatch = !isNewMatch;
      // });

      if (!isAnonymous) {
        addPredictedMatch(
          widget.homeName,
          widget.awayName,
          widget.homeLogo,
          widget.awayLogo,
          _resultHome,
          _resultAway,
          widget.leagueName,
          widget.leagueNumber,
          widget.matchId,
          widget.matchTime,
        );
      } else {
        // if (predictedMatchId == widget.matchId) {
        //   print('dfgdfg $predictedMatchId');
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: const Text('Ten mecz jest już dodany!'),
        //     ),
        //   );
        //   Navigator.of(context).pop();
        //   return;
        // }
        Provider.of<PredictedMatchProvider>(context, listen: false).addMatch(
          {
            'teamHomeName': widget.homeName,
            'teamHomeLogo': widget.homeLogo,
            'teamHomeGoal': _resultHome,
            'teamAwayName': widget.awayName,
            'teamAwayLogo': widget.awayLogo,
            'teamAwayGoal': _resultAway,
            'matchTime': widget.matchTime,
            'matchId': widget.matchId,
            'leagueName': widget.leagueName,
            'leagueNumber': widget.leagueNumber
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Mecz został dodany!'),
            // action: SnackBarAction(
            //     label: 'Zobacz',
            //     onPressed: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => PredictedScreen(),
            //       ));
            //     }),
          ),
        );
      }

      // Navigator.of(context).pop(isNewMatch);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Predict the result',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 130,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.homeName,
                                  style: const TextStyle(fontSize: 17),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.homeLogo,
                                    fadeInDuration: Duration(milliseconds: 50),
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    width: 45.0,
                                  ),
                                  // child: Image.network(
                                  //   widget.teamHomeLogo,
                                  //   width: 45.0,
                                  //   // height: 36.0,
                                  // ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  autofocus: false,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '?',
                                    errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                    ),
                                    border: const OutlineInputBorder(),
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.greenAccent),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  initialValue: "",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wpisz poprawną liczbę';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _resultHome = int.parse(value!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 14,
                        child: const Text(
                          "-",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  autofocus: false,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '?',
                                    errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                    ),
                                    border: const OutlineInputBorder(),
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.greenAccent),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  initialValue: "",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wpisz poprawn liczbę';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _resultAway = int.parse(value!);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              width: 130,
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.awayName,
                                    style: const TextStyle(fontSize: 17),
                                    softWrap: true,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.awayLogo,
                                      fadeInDuration: Duration(milliseconds: 50),
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      width: 45.0,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     OutlinedButton(
                //       onPressed: () {},
                //       style: OutlinedButton.styleFrom(
                //         foregroundColor: Color.fromARGB(255, 56, 179, 60),
                //         elevation: 15.0,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //       ),
                //       child: const Text('Zwycięstwo'),
                //     ),
                //     OutlinedButton(
                //       onPressed: () {},
                //       style: OutlinedButton.styleFrom(
                //         foregroundColor: Color.fromARGB(255, 56, 179, 60),
                //         elevation: 15.0,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //       ),
                //       child: const Text('Remis'),
                //     ),
                //     OutlinedButton(
                //       onPressed: () {},
                //       style: OutlinedButton.styleFrom(
                //         foregroundColor: Color.fromARGB(255, 56, 179, 60),
                //         elevation: 15.0,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //       ),
                //       child: const Text('Zwycięstwo'),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _savePredictResult,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, //change background color of button
                      backgroundColor: const Color.fromARGB(255, 40, 122, 43), //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text('Save'),
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
