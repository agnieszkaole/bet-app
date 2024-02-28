import 'package:bet_app/src/models/soccermodel.dart';
import 'package:flutter/material.dart';

class ScoreboardProvider extends ChangeNotifier {
  List<SoccerMatch> _scoreboardMatchesList = [];
  List<SoccerMatch> get scoreboardMatchesList => _scoreboardMatchesList;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void saveMatches(List<SoccerMatch> matches) {
    _scoreboardMatchesList = matches;
  }

  void clearMatches() {
    _scoreboardMatchesList.clear();
    notifyListeners();
  }

  void sortMatchesByDate(List<SoccerMatch> matches) {
    matches.sort((a, b) => a.fixture.date.compareTo(b.fixture.date));
  }
}
