import "dart:core";
import 'package:bet_app/src/services/soccer_api_service.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class GetApiData extends StatefulWidget {
  const GetApiData({
    super.key,
    this.leagueNumber,
  });
  final String? leagueNumber;

  @override
  State<GetApiData> createState() => _GetApiDataState();
}

class _GetApiDataState extends State<GetApiData> {
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
              // Future.delayed(const Duration(seconds: 3));

              // Provider.of<NextMatchesProvider>(context, listen: false)
              //     .clearMatches();

              // Provider.of<NextMatchesProvider>(context, listen: false)
              //     .saveMatches(snapshot.data!);
              // Provider.of<NextMatchesProvider>(context, listen: false)
              //     .saveMatches(snapshot.data!);

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
