import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:provider/provider.dart';
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
    final predictedMatchList =
        context.watch<PredictedMatchProvider>().predictedMatchList;
    // print(predictedMatchList);
    return (predictedMatchList.isEmpty)
        ? const Center(
            child: Text(
              'Nie dodano żadnych zakładów',
              style: TextStyle(fontSize: 16),
            ),
          )
        : Column(
            children: [
              const Text(
                'Edycja jest możliwa tylko do 2 godzin przed meczem',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 15),
              const Text(
                'Mistrzostwa Europy 2024 - kwalifikacje',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictedMatchList.length,
                  itemBuilder: (context, index) => PredictedItem(
                    predictedMatch: predictedMatchList[index],
                    key: ValueKey(predictedMatchList[index]),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
  }
}
