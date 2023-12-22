import "package:bet_app/widgets/predicted_list.dart";
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
        appBar: AppBar(
          title: const Text('Ranking'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lista rankingowa',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '1. Maciej',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '2. Staś',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '3. Grzesiek',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '4. Michał',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '5. Piotrek',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
