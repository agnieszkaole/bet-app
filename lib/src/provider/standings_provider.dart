import 'package:bet_app/src/models/league_standings.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:flutter/material.dart';

class StandingsProvider extends ChangeNotifier {
  List<LeagueStandings> _standingsList = [];
  List<LeagueStandings> get standingsList => _standingsList;

  void saveStandings(List<LeagueStandings> standings) {
    _standingsList = standings;
    notifyListeners();
  }

  void clearStandings() {
    _standingsList.clear();
    notifyListeners();
  }
}
