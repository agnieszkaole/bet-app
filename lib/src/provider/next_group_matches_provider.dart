import 'package:bet_app/src/models/soccermodel.dart';
import 'package:flutter/material.dart';

class NextGroupMatchesProvider extends ChangeNotifier {
  List<SoccerMatch> _nextGroupMatchesList = [];
  List<SoccerMatch> get nextMatchesList => _nextGroupMatchesList;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void saveMatches(List<SoccerMatch> matches) {
    _nextGroupMatchesList = matches;
    notifyListeners();
  }

  void clearMatches() {
    _nextGroupMatchesList.clear();
    notifyListeners();
  }

  static void sortMatchesByDate(List<SoccerMatch> matches) {
    final sortedMatches = matches.sort((a, b) => a.fixture.date.compareTo(b.fixture.date));
    return sortedMatches;
  }
}
