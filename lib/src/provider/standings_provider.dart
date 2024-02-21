import 'package:bet_app/src/models/match_ranking.dart';
import 'package:flutter/material.dart';

class StandingsProvider extends ChangeNotifier {
  List<MatchRanking> _standingsList = [];
  List<MatchRanking> get standingsList => _standingsList;

  void saveStandings(List<MatchRanking> ranking) {
    _standingsList = ranking;

    notifyListeners();
  }

  void clearStandings() {
    _standingsList.clear();
    notifyListeners();
  }
}
