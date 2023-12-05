import 'package:bet_app/widgets/match_item.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/data/dummy_data.dart';

class MatchList extends StatefulWidget {
  const MatchList({super.key});

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) => MatchItem(
              matchData: matches[index],
            ),
          ),
        ),
      ],
    );
  }
}
