import 'package:bet_app/src/models/soccermodel.dart';
import 'package:flutter/material.dart';

class NextMatchesProvider extends ChangeNotifier {
  List<SoccerMatch> _nextMatchesList = [];
  List<SoccerMatch> get nextMatchesList => _nextMatchesList;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void saveMatches(List<SoccerMatch> matches) {
    _nextMatchesList = matches;
    notifyListeners();
  }

  void clearMatches() {
    _nextMatchesList.clear();
    notifyListeners();
  }

  static void sortMatchesByDate(List<SoccerMatch> matches) {
    final sortedMatches = matches.sort((a, b) => a.fixture.date.compareTo(b.fixture.date));
    return sortedMatches;
  }
}
