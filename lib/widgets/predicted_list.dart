import 'package:bet_app/models/soccermodel.dart';
import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:provider/provider.dart';
import 'package:bet_app/widgets/predicted_item.dart';
import 'package:flutter/material.dart';

class PredictedList extends StatefulWidget {
  const PredictedList({
    super.key,
    this.match,
  });
  final SoccerMatch? match;
  @override
  State<PredictedList> createState() => _PredictedListState();
}

class _PredictedListState extends State<PredictedList> {
  @override
  Widget build(BuildContext context) {
    final predictedMatchList =
        context.watch<PredictedMatchProvider>().predictedMatchList;

    return (predictedMatchList.isEmpty)
        ? const Center(
            child: Text(
              'Nie dodano żadnych zakładów',
              style: TextStyle(fontSize: 16),
            ),
          )
        : Column(
            children: [
              // const Text(
              //   'Edycja jest możliwa tylko do 2 godzin przed meczem',
              //   style: TextStyle(fontSize: 13),
              // ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: predictedMatchList.length,
                  itemBuilder: (context, index) => PredictedItem(
                    predictedMatch: predictedMatchList[index],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
  }
}
