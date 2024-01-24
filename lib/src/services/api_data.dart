import "dart:core";
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ApiData extends StatefulWidget {
  const ApiData({
    super.key,
    this.leagueNumber,
  });
  final String? leagueNumber;

  @override
  State<ApiData> createState() => _ApiDataState();
}

class _ApiDataState extends State<ApiData> {
  late Future dataFuture;
  late Future leagueFuture;
  String? statusApi = 'ns-tbd';
  String? seasonApi;
  String? leagueApi;
  String? liveApi = '';

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
    // leagueFuture = _fetchDataForNewLeague();
  }

  Future<List<SoccerMatch>> _getData() async {
    final season1Data = await SoccerApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2023',
      status: statusApi,
      live: liveApi,
    );

    final season2Data = await SoccerApi().getMatches(
      '',
      league: widget.leagueNumber,
      season: '2024',
      status: statusApi,
      live: liveApi,
    );

    List<SoccerMatch> mergedData = [];
    mergedData.addAll(season1Data);
    mergedData.addAll(season2Data);

    Provider.of<NextMatchesProvider>(context, listen: false)
        .saveMatches(mergedData);

    return mergedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: dataFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(
                child: Text('$error',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20)),
              );
            } else if (snapshot.hasData) {
              // if (statusApi == 'ns-tbd') {

              return HomeScreen();
              // return const SizedBox();
              // }
            }
          }
          throw Exception('cos jest nie tak');
        },
      ),
    );
  }
}
