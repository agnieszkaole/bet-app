import 'package:flutter/material.dart';

class MatchIdProvider extends ChangeNotifier {
  String _selectedMatchId = '1036013';

  String get selectedMatchId => _selectedMatchId;

  void updateSelectedMatchId(String matchId) {
    _selectedMatchId = matchId;
    notifyListeners();
  }

  // void clearSelectedMatchId() {
  //   _selectedMatchId = '';
  // }
}
