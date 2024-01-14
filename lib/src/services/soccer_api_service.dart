import 'dart:async';
import 'dart:convert';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
// import 'package:envied/envied.dart';
// import 'package:envied_generator/envied_generator.dart';
// import 'package:build_runner/build_runner.dart';
// import 'package:bet_app/env.dart';

class SoccerApi {
  static const _baseUrl = "https://v3.football.api-sports.io/fixtures?";
  // static const liveApi = '$_baseUrl?live=all';
  // static const prevApi =
  //     '$_baseUrl?last=20&status=ft-aet-pen&league=960&season=2023';
  // static const byDateApi = '$_baseUrl?status=ns-tbd&date=;

  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "210d8f8075e74dbbfc3f783d1b574c19",
  };

  Future getMatches(date, {league, season, status, live}) async {
    String? dateUrl = date == "" ? "" : "date=$date";
    String? leagueUrl = league == "" ? "" : '&league=$league';
    String? seasonUrl = season == "" ? "" : '&season=$season';
    String? statusUrl = status == "" ? "" : '&status=$status';
    String? liveUrl = live == "" ? "" : '&live=$live';

    Response res = await get(
        // Uri.parse('$_baseUrl$dateUrl$leagueUrl$seasonUrl$statusUrl$liveUrl'),
        // headers: headers);
        Uri.parse('$_baseUrl$dateUrl$leagueUrl$seasonUrl$statusUrl$liveUrl'),
        headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> matchesList = data['response'];
      // print(matchesList.length);
      List<SoccerMatch> matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();
      return matches;
    }
    throw Exception('wystąpił błąd połączenia');
  }
}
