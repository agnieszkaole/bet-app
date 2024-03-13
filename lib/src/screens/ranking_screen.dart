import 'package:bet_app/src/widgets/main_drawer.dart';
import "package:flutter/material.dart";

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Ranking'),
        // ),
        // drawer: const MainDrawer(),
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lista rankingowa',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '1. ..........',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '2. ..........',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '3. ..........',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '4. ..........',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '5. ..........',
          style: TextStyle(fontSize: 16),
        ),
      ],
    ));
  }
}
