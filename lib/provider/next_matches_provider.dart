import 'package:bet_app/models/soccermodel.dart';
import 'package:flutter/material.dart';

class NextMatchesProvider extends ChangeNotifier {
  List<SoccerMatch> _nextMatchesList = [];
  List<SoccerMatch> get nextMatchesList => _nextMatchesList;

  void saveMatches(List<SoccerMatch> matches) {
    _nextMatchesList = matches;
    notifyListeners();
  }

  void clearMatches() {
    _nextMatchesList.clear();
    notifyListeners();
  }
}
