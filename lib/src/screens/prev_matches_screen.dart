import "dart:core";
import 'package:bet_app/src/widgets/prev_match_list.dart';
import "package:flutter/material.dart";

class PrevMatchesScreen extends StatefulWidget {
  const PrevMatchesScreen({super.key});

  @override
  State<PrevMatchesScreen> createState() => _PrevMatchesScreenState();
}

class _PrevMatchesScreenState extends State<PrevMatchesScreen> {
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = _getData();
  }

  _getData() async {
    // return await SoccerApi().getPrevMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyniki meczów'),
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
              return prevMatchList(snapshot.data!);
            }
          }
          throw Exception('cos jest nie tak');
        },
      ),
    );
  }
}
