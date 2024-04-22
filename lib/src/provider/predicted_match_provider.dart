import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PredictedMatchProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> predictedMatchList = [];
  // static const String _predictedMatchesKey = 'predictedMatches';

  // PredictedMatchProvider() {
  //   _loadMatches();
  // }

  // Future<void> _loadMatches() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final List<String>? savedMatches =
  //       prefs.getStringList(_predictedMatchesKey);

  //   if (savedMatches != null) {
  //     predictedMatchList.addAll(savedMatches.map((matchString) {
  //       return Map<String, dynamic>.from(json.decode(matchString));
  //     }));
  //     notifyListeners();
  //   }
  // }

  // Future<void> _saveMatches() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // final List<String> matchStrings =
  //     predictedMatchList.map((match) => json.encode(match)).toList();
  // prefs.setStringList(_predictedMatchesKey, matchStrings);
  // }
  List<Map<String, dynamic>> getPredictedMatches() {
    return List<Map<String, dynamic>>.from(predictedMatchList);
  }

  void addMatch(Map<String, dynamic> match) {
    if (predictedMatchList.every((predictedMatch) => predictedMatch['matchId'] != match['matchId'])) {
      predictedMatchList.add(match);

      notifyListeners();
    }
  }

  bool isMatchAdded(int matchId) {
    return predictedMatchList.any((predictedMatch) => predictedMatch['matchId'] == matchId);
  }

  void removeMatch(Map<String, dynamic> match) {
    predictedMatchList.remove(match);

    notifyListeners();
  }

  List<Map<String, dynamic>> showMatchesByLeague(int? league) {
    return predictedMatchList.where((match) => match['leagueNumber'] == league).toList();
  }

  void updateMatchResult(int matchId, int teamHomeGoal, int teamAwayGoal) {
    int matchIndex = predictedMatchList.indexWhere((predictedMatch) => predictedMatch['matchId'] == matchId);

    if (matchIndex != -1) {
      predictedMatchList[matchIndex]['teamHomeGoal'] = teamHomeGoal;
      predictedMatchList[matchIndex]['teamAwayGoal'] = teamAwayGoal;

      notifyListeners();
    }
  }
}
