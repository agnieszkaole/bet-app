import 'package:bet_app/src/models/soccermodel.dart';
import 'package:flutter/material.dart';

class NextMatchesScheduledProvider extends ChangeNotifier {
  List<SoccerMatch> _nextMatchesScheduledList = [];
  List<SoccerMatch> get nextMatchesScheduledList => _nextMatchesScheduledList;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void saveMatches(List<SoccerMatch> matches) {
    _nextMatchesScheduledList = matches;
    notifyListeners();
  }

  void clearMatches() {
    _nextMatchesScheduledList.clear();
    notifyListeners();
  }

  static void sortMatchesByDate(List<SoccerMatch> matches) {
    final sortedMatches = matches.sort((a, b) => a.fixture.date.compareTo(b.fixture.date));
    return sortedMatches;
  }
}
