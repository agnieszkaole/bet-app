import 'package:bet_app/src/models/soccermodel.dart';
import 'package:flutter/material.dart';

class PrevMatchesProvider extends ChangeNotifier {
  List<SoccerMatch> _prevMatchesList = [];
  List<SoccerMatch> get prevMatchesList => _prevMatchesList;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void saveMatches(List<SoccerMatch> matches) {
    _prevMatchesList = matches;

    notifyListeners();
  }

  void clearMatches() {
    _prevMatchesList.clear();
    notifyListeners();
  }

  static void sortMatchesByDate(List<SoccerMatch> matches) {
    final sortedMatches =
        matches.sort((a, b) => a.fixture.date.compareTo(b.fixture.date));
    return sortedMatches;
  }
}
