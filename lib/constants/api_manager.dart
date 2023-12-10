import 'dart:async';
import 'dart:convert';
import 'package:bet_app/models/soccermodel.dart';
import 'package:http/http.dart';

class SoccerApi {
  static const _baseUrl = "https://v3.football.api-sports.io/fixtures";
  static const liveApi = '$_baseUrl?live=all';
  static const prevApi =
      '$_baseUrl?last=20&status=ft-aet-pen&league=960&season=2023';
  static const byDateApi = '$_baseUrl?status=ns-tbd&league=2&season=2023&date=';

  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "210d8f8075e74dbbfc3f783d1b574c19",
  };

  Future getNextMatches(date) async {
    Response res = await get(Uri.parse(byDateApi + date), headers: headers);
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
  // Future getNextMatches() async {
  //   Response res = await get(Uri.parse(nextApi), headers: headers);
  //   if (res.statusCode == 200) {
  //     var data = jsonDecode(res.body);
  //     List<dynamic> matchesList = data['response'];
  //     print(matchesList.length);
  //     List<SoccerMatch> matches = matchesList
  //         .map((dynamic item) => SoccerMatch.fromJson(item))
  //         .toList();
  //     return matches;
  //   }
  //   throw Exception('wystąpił błąd połączenia');
  // }

  // Future getLiveMatches() async {
  //   Response res = await get(Uri.parse(liveApi), headers: headers);
  //   if (res.statusCode == 200) {
  //     var data = jsonDecode(res.body);
  //     List<dynamic> matchesList = data['response'];
  //     print(matchesList.length);
  //     List<SoccerMatch> matches = matchesList
  //         .map((dynamic item) => SoccerMatch.fromJson(item))
  //         .toList();
  //     return matches;
  //   }
  //   throw Exception('wystąpił błąd połączenia');
  // }

  // Future getPrevMatches() async {
  //   Response res = await get(Uri.parse(prevApi), headers: headers);
  //   if (res.statusCode == 200) {
  //     var data = jsonDecode(res.body);
  //     List<dynamic> matchesList = data['response'];
  //     print(matchesList.length);
  //     List<SoccerMatch> matches = matchesList
  //         .map((dynamic item) => SoccerMatch.fromJson(item))
  //         .toList();
  //     return matches;
  //   }
  //   throw Exception('wystąpił błąd połączenia');
  // }
}

// final String apiUrl =
//     "https://v3.football.api-sports.io/fixtures?league=727&season=2023";

  // final String apiUrl =
  //     "https://v3.football.api-sports.io/fixtures?date=2023-11-29&league=2&season=2023";
  // final String apiUrl =
  //     "https://v3.football.api-sports.io/fixtures?league=960&season=2023&team=24";
  // final String apiUrl = "https://v3.football.api-sports.io/fixtures?next=10";