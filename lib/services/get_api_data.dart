import "dart:core";
import "package:bet_app/constants/api_manager.dart";
import "package:bet_app/widgets/next_match_list.dart";
import "package:flutter/material.dart";

class GetApiData extends StatefulWidget {
  GetApiData({super.key, required this.leagueApi});

  final String? leagueApi;

  @override
  State<GetApiData> createState() => _GetApiDataState();
}

class _GetApiDataState extends State<GetApiData> {
  late Future dataFuture;
  // String? leagueNumber;
  String? statusApi = 'ns-tbd';
  String? seasonApi = '2023';
  // String? leagueApi = '2';
  // String? leagueApi = "";
  String? liveApi = '';

  _getData() async {
    return await SoccerApi().getMatches('',
        league: widget.leagueApi,
        season: seasonApi,
        status: statusApi,
        live: liveApi);
  }

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
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
              return Text('$error',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
            } else if (snapshot.data!.isEmpty) {
              return Expanded(
                child: Container(
                  width: double.infinity,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Brak meczów do wyświetlenia.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Nie została wybrana liga  lub \n nie są rozgrywane mecze w wybranej kategorii.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              if (statusApi == 'ns-tbd') {
                // print('przekazane argumenty: $arguments');
                return NextMatchList(matches: snapshot.data!);
              }
            }
          }
          throw Exception('cos jest nie tak');
        },
      ),
    );
  }
}
