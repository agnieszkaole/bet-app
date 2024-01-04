import "dart:core";
import "package:bet_app/widgets/next_match_list.dart";
import "package:flutter/material.dart";

class NextMatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bet',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        body: const NextMatchList());
  }
}
