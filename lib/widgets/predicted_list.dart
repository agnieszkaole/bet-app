import 'package:bet_app/widgets/predicted_item.dart';
import 'package:flutter/material.dart';

class PredictedList extends StatefulWidget {
  const PredictedList({super.key});

  @override
  State<PredictedList> createState() => _PredictedListState();
}

class _PredictedListState extends State<PredictedList> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: matches.length,
        //     itemBuilder: (context, index) => PredictedItem(),
        //   ),
        // ),
        PredictedItem()
      ],
    );
  }
}
