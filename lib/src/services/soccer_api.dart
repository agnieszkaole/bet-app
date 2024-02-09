import 'dart:async';
import 'dart:convert';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:http/http.dart';
// import 'package:envied/envied.dart';
// import 'package:envied_generator/envied_generator.dart';
// import 'package:build_runner/build_runner.dart';
// import 'package:bet_app/env.dart';

class SoccerApi {
  static const _baseUrl = "https://v3.football.api-sports.io/fixtures?";

  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "210d8f8075e74dbbfc3f783d1b574c19",
  };

  Future getMatches(date, {league, season, status, timezone}) async {
    String? dateUrl = date.isEmpty ? "" : "date=$date";
    String? leagueUrl = league?.isEmpty ?? true ? "" : '&league=$league';
    String? seasonUrl = season?.isEmpty ?? true ? "" : '&season=$season';
    String? statusUrl = status?.isEmpty ?? true ? "" : '&status=$status';
    String? timezoneUrl = '&timezone=$timezone';

    Response res = await get(
        Uri.parse(
            '$_baseUrl$dateUrl$leagueUrl$seasonUrl$statusUrl$timezoneUrl'),
        headers: headers);

    print('$_baseUrl$dateUrl$leagueUrl$seasonUrl$statusUrl$timezoneUrl');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> matchesList = data['response'];
      List<SoccerMatch> matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();

      return matches;
    }
    throw Exception('wystąpił błąd połączenia');
  }
}
