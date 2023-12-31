import 'package:flutter/material.dart';

class PredictedMatchProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> predictedMatchList = [];

  void addMatch(Map<String, dynamic> match) {
    if (predictedMatchList.every(
        (predictedMatch) => predictedMatch['matchId'] != match['matchId'])) {
      predictedMatchList.add(match);
      notifyListeners();
      // print(predictedMatchList);
    }
  }

  void removeMatch(Map<String, dynamic> match) {
    predictedMatchList.remove(match);
    notifyListeners();
    // print(predictedMatchList.length);
  }
}
