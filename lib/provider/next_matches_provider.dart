import 'package:bet_app/models/soccermodel.dart';
import 'package:flutter/material.dart';

class NextMatchesProvider extends ChangeNotifier {
  List<SoccerMatch> nextMatchesList = [];

  void saveMatches(List<SoccerMatch> matches) {
    nextMatchesList.addAll(matches);
  }
  // notifyListeners();

  void clearMatches() {
    nextMatchesList.clear();
    //   // notifyListeners();
  }
}
