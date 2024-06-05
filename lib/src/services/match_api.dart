import 'dart:async';
import 'dart:convert';
import 'package:bet_app/src/models/match_predictions_model.dart';
import 'package:bet_app/src/models/league_standings.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:http/http.dart';
// import 'package:envied/envied.dart';
// import 'package:envied_generator/envied_generator.dart';
// import 'package:build_runner/build_runner.dart';
// import 'package:bet_app/env.dart';

class MatchApi {
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

  Future<List<PredictionData>> getPredictions(String? fixture) async {
    String fixtureUrl = fixture!.isEmpty ? "" : "fixture=$fixture";

    Response res = await get(Uri.parse('$_baseUrlPredictions$fixtureUrl'), headers: headers);

    print('$_baseUrlPredictions$fixtureUrl');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      var response = data['response'];

      List<PredictionData> predictions = response.map<PredictionData>((item) {
        return PredictionData.fromJson(item);
      }).toList();

      return predictions;
    } else {
      print(res.statusCode);
      throw Exception('Failed to fetch predictions. Status code: ${res.statusCode}');
    }
  }

  Future<List<LeagueStandings>> getStandings(String? league, String? season) async {
    try {
      final String leagueUrl = league != null ? 'league=$league' : '';
      final String seasonUrl = season != null ? '&season=$season' : '';

      Response res = await get(Uri.parse('$_baseUrlStandings$leagueUrl$seasonUrl'), headers: headers);

      if (res.statusCode == 200) {
        // Parse the response body
        final dynamic data = jsonDecode(res.body);

        // Check if the response contains the expected data structure
        if (data is Map<String, dynamic> && data.containsKey('response')) {
          final List<dynamic> rankingRes = data['response'];
          final List<LeagueStandings> standings = [];
          print(rankingRes);

          // Iterate over the ranking results
          for (var leagueData in rankingRes) {
            // Check if 'league' data is available
            if (leagueData != null && leagueData['league'] != null && leagueData['league']['standings'] != null) {
              final dynamic leagueStandings = leagueData['league']['standings'];

              // Check if standings data is available and is a list
              if (leagueStandings is List && leagueStandings.isNotEmpty) {
                final List<dynamic> standingsList = leagueStandings[0];
                standings.addAll(standingsList.map((dynamic item) => LeagueStandings.fromJson(item)));
              } else {
                print('Standings data is missing or empty for this league.');
              }
            } else {
              print('League data is missing or invalid.');
            }
          }
          return standings;
        } else {
          throw Exception('Invalid JSON format: Missing or invalid response structure');
        }
      } else {
        throw Exception('Received non-200 status code: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching standings: $e');
    }
  }
}
