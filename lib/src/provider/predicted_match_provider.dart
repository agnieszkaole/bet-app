import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PredictedMatchProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> predictedMatchList = [];
  static const String _predictedMatchesKey = 'predictedMatches';

  PredictedMatchProvider() {
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedMatches =
        prefs.getStringList(_predictedMatchesKey);

    if (savedMatches != null) {
      predictedMatchList.addAll(savedMatches.map((matchString) {
        return Map<String, dynamic>.from(json.decode(matchString));
      }));
      notifyListeners();
    }
  }

  Future<void> _saveMatches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> matchStrings =
        predictedMatchList.map((match) => json.encode(match)).toList();
    prefs.setStringList(_predictedMatchesKey, matchStrings);
  }

  void addMatch(Map<String, dynamic> match) {
    if (predictedMatchList.every(
        (predictedMatch) => predictedMatch['matchId'] != match['matchId'])) {
      predictedMatchList.add(match);
      // print(predictedMatchList);
      // print(match);
      notifyListeners();
      _saveMatches();
    }
  }

  void removeMatch(Map<String, dynamic> match) {
    predictedMatchList.remove(match);
    // print(predictedMatchList);
    // print(match);
    notifyListeners();
    _saveMatches();
  }

  void updateMatchResult(int matchId, int teamHomeGoal, int teamAwayGoal) {
    int matchIndex = predictedMatchList
        .indexWhere((predictedMatch) => predictedMatch['matchId'] == matchId);

    if (matchIndex != -1) {
      predictedMatchList[matchIndex]['teamHomeGoal'] = teamHomeGoal;
      predictedMatchList[matchIndex]['teamAwayGoal'] = teamAwayGoal;

      notifyListeners();
      _saveMatches();
    }
  }

  // void addMatch(Map<String, dynamic> match) {
  //   if (predictedMatchList.every(
  //       (predictedMatch) => predictedMatch['matchId'] != match['matchId'])) {
  //     predictedMatchList.add(match);
  //     notifyListeners();
  //     // print(predictedMatchList);
  //   }
  // }

  // void removeMatch(Map<String, dynamic> match) {
  //   predictedMatchList.remove(match);
  //   notifyListeners();
  // print(predictedMatchList.length);
  // }
}
