import 'dart:async';
import 'dart:convert';
import 'package:bet_app/models/soccermodel.dart';
import 'package:http/http.dart';

class SoccerApi {
  // final String apiUrl = "https://v3.football.api-sports.io/fixtures?live=all&timezone=Europe/Warsaw";
  // final String apiUrl =
  //     "https://v3.football.api-sports.io/fixtures?date=2023-11-29&league=2&season=2023";
  // final String apiUrl =
  //     "https://v3.football.api-sports.io/fixtures?league=960&season=2023&team=24";
  final String apiUrl =
      "https://v3.football.api-sports.io/fixtures?date=2023-12-07";

  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "210d8f8075e74dbbfc3f783d1b574c19",
  };

  Future getAllMatches() async {
    Response res = await get(Uri.parse(apiUrl), headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      List<dynamic> matchesList = data['response'];

      print(matchesList.length);

      List<SoccerMatch> matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();

      return matches;
    }

    throw Exception('wystąpił błąd połączenia');
  }
}
