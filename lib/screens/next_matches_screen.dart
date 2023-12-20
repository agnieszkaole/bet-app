import "dart:core";
import "package:bet_app/constants/api_manager.dart";
import 'package:bet_app/widgets/next_match_list.dart';
import "package:flutter/material.dart";

class NextMatchesScreen extends StatefulWidget {
  const NextMatchesScreen({super.key});

  @override
  State<NextMatchesScreen> createState() => _NextMatchesScreenState();
}

class _NextMatchesScreenState extends State<NextMatchesScreen> {
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  _getData() async {
    return await SoccerApi()
        .getMatches('', league: '110', season: "2023", status: 'ns-tbd');
    // .getMatches('', league: '2', season: "2023", status: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Zdecyduj, który mecz chcesz obstawić',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
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
              return const Center(
                child: Text("Brak danych do wyświetlenia"),
              );
            } else if (snapshot.hasData) {
              return NextMatchList(matches: snapshot.data!);
            }
          }
          throw Exception('cos jest nie tak');
        },
      ),
    );
  }
}

// class MatchesList {
//   MatchesList(param0, {required allmatches});
// }