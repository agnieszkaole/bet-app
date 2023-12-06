import "dart:core";
import "package:bet_app/constants/api_manager.dart";
import 'package:bet_app/widgets/pagebody.dart';
import "package:flutter/material.dart";

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Najbliższe mecze',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: const SoccerApp(),
    );
  }
}

class SoccerApp extends StatefulWidget {
  const SoccerApp({super.key});

  @override
  State<SoccerApp> createState() => _SoccerAppState();
}

class _SoccerAppState extends State<SoccerApp> {
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  _getData() async {
    return await SoccerApi().getAllMatches();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
              return PageBody(snapshot.data!);
            }
          }
          throw Exception('cos jest nie tak');
        });
  }
}
