import 'dart:async';
import 'dart:convert';
import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/models/match_ranking.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:http/http.dart';
// import 'package:envied/envied.dart';
// import 'package:envied_generator/envied_generator.dart';
// import 'package:build_runner/build_runner.dart';
// import 'package:bet_app/env.dart';

class SoccerApi {
  static const _baseUrlFixture = "https://v3.football.api-sports.io/fixtures?";
  static const _baseUrlStandings = "https://v3.football.api-sports.io/standings?";
  static const _baseUrlPredictions = "https://v3.football.api-sports.io/predictions?";

  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "210d8f8075e74dbbfc3f783d1b574c19",
  };

  Future getMatches(date, {league, season, status, next, last, from, to, timezone}) async {
    String? dateUrl = date.isEmpty ? "" : "date=$date";
    String? leagueUrl = league?.isEmpty ?? true ? "" : '&league=$league';
    String? seasonUrl = season?.isEmpty ?? true ? "" : '&season=$season';
    String? statusUrl = status?.isEmpty ?? true ? "" : '&status=$status';
    String? nextUrl = next?.isEmpty ?? true ? "" : '&next=$next';
    String? lastUrl = last?.isEmpty ?? true ? "" : '&last=$last';
    String? fromUrl = from?.isEmpty ?? true ? "" : '&from=$from';
    String? toUrl = to?.isEmpty ?? true ? "" : '&to=$to';
    String? timezoneUrl = '&timezone=$timezone';

    Response res = await get(
        Uri.parse('$_baseUrlFixture$dateUrl$leagueUrl$seasonUrl$statusUrl$nextUrl$lastUrl$fromUrl$toUrl$timezoneUrl'),
        headers: headers);

    print('$_baseUrlFixture$dateUrl$leagueUrl$seasonUrl$statusUrl$nextUrl$lastUrl$fromUrl$toUrl$timezoneUrl');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> matchesList = data['response'];
      List<SoccerMatch> matches = matchesList.map((dynamic item) => SoccerMatch.fromJson(item)).toList();

      return matches;
    }
    throw Exception('wystąpił błąd połączenia');
  }

  Future getPredictions(String fixture) async {
    String fixtureUrl = fixture.isEmpty ? "" : "fixture=$fixture";

    Response res = await get(Uri.parse('$_baseUrlPredictions$fixtureUrl'), headers: headers);

    print('$_baseUrlPredictions$fixtureUrl');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      var response = data['response'];

      if (response.isNotEmpty) {
        List<PredictionData> predictions = response.map<PredictionData>((item) {
          return PredictionData.fromJson(item);
        }).toList();

        return predictions;
      } else {
        throw Exception('No predictions available');
      }
    } else {
      throw Exception('Failed to fetch predictions. Status code: ${res.statusCode}');
    }
  }

  // Future getStandings({league, season}) async {
  //   String leagueUrl = league?.isEmpty ?? true ? "" : 'league=$league';
  //   String seasonUrl = season?.isEmpty ?? true ? "" : '&season=$season';

  //   Response res = await get(Uri.parse('$_baseUrlStandings$leagueUrl$seasonUrl'), headers: headers);

  //   print('$_baseUrlStandings$leagueUrl$seasonUrl');
  //   if (res.statusCode == 200) {
  //     var data = jsonDecode(res.body);
  //     List<dynamic> rankingRes = data['response'];
  //     List rankings = [];
  //     for (var leagueData in rankingRes) {
  //       var standings = leagueData['league']['standings'];
  //       print(standings);
  //       if (standings != null && standings.isNotEmpty) {
  //         List<dynamic> rankingList = standings[0];
  //         rankings.addAll(rankingList.map((dynamic item) => MatchRanking.fromJson(item)));

  //         print(rankings.length);
  //       }
  //     }
  //     return rankings;
  //   } else {
  //     print('Received non-200 status code: ${res.statusCode}');
  //     throw Exception('wystąpił błąd połączenia');
  //   }
  // }
}
