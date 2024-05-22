// import 'dart:convert';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';

import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/widgets/match_prediction_list.dart';

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
    this.homeName,
    this.awayName,
    this.homeLogo,
    this.awayLogo,
    this.matchTime,
    this.matchId,
    this.match,
    this.leagueName,
    this.leagueNumber,
    this.groupId,
    this.selectedLeagueNumber,
  });

  final String? homeName;
  final String? awayName;
  final String? homeLogo;
  final String? awayLogo;
  final String? matchTime;
  final int? matchId;
  final SoccerMatch? match;
  final String? leagueName;
  final int? leagueNumber;
  final String? groupId;
  final String? selectedLeagueNumber;

  @override
  State<PredictResult> createState() => _PredictResultState();
}

class _PredictResultState extends State<PredictResult> {
  int? _resultHome;
  int? _resultAway;
  // String? _goalNumberError;
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

  Future<void> addPredictedMatch(String? homeName, String? awayName, String? homeLogo, String? awayLogo, int? homeGoal,
      int? awayGoal, String? leagueName, int? leagueNumber, int? matchId, String? matchTime) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not authenticated');
        return;
      }

      final existingPrediction = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('predictions')
          .where('matchId', isEqualTo: matchId)
          .where('groupId', isEqualTo: widget.groupId)
          .get();

      if (existingPrediction.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prediction for this match already exists.'),
          ),
        );

        return;
      }

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
        'groupId': widget.groupId
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
        addPredictedMatch(widget.homeName, widget.awayName, widget.homeLogo, widget.awayLogo, _resultHome, _resultAway,
            widget.leagueName, widget.leagueNumber, widget.matchId, widget.matchTime);
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
            'leagueNumber': widget.leagueNumber,
            'groupId': widget.groupId
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mecz został dodany!'),
          ),
        );
      }

      // Navigator.of(context).pop();
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: const Color.fromARGB(255, 26, 26, 26),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            padding: const EdgeInsets.all(10),
                            width: 130,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.homeName!,
                                  style: const TextStyle(fontSize: 17),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.homeLogo!,
                                    fadeInDuration: const Duration(milliseconds: 50),
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
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                                      height: 0,
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                                      return '';
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
                      const SizedBox(
                        width: 14,
                        child: Text(
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
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                                      height: 0,
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                                      // return 'Wpisz poprawn liczbę';
                                      return '';
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
                              padding: const EdgeInsets.all(10),
                              width: 130,
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.awayName!,
                                    style: const TextStyle(fontSize: 17),
                                    softWrap: true,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.awayLogo!,
                                      fadeInDuration: const Duration(milliseconds: 50),
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
                // const SizedBox(height: 20),
                MatchPredictionList(leagueNumber: widget.selectedLeagueNumber, matchId: widget.matchId.toString()),
                const SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _savePredictResult,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 40, 122, 43),
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
