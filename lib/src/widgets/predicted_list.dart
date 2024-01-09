import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:provider/provider.dart';
import 'package:bet_app/src/widgets/predicted_item.dart';
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
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final predictedMatchList =
        context.watch<PredictedMatchProvider>().predictedMatchList;

    return (predictedMatchList.isEmpty)
        ? const Center(
            child: Text(
              'Nie dodano żadnych zakładów.',
              style: TextStyle(fontSize: 20),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Wytypowane mecze',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RawScrollbar(
                  // thumbVisibility: true,
                  trackVisibility: true,
                  trackColor: Color.fromARGB(43, 40, 122, 43),
                  thumbColor: const Color.fromARGB(255, 40, 122, 43),
                  controller: _scrollController,
                  radius: const Radius.circular(10),
                  crossAxisMargin: 2,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: predictedMatchList.length,
                    itemBuilder: (context, index) => PredictedItem(
                      predictedMatch: predictedMatchList[index],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
  }
}
