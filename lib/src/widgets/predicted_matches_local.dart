import "package:bet_app/src/provider/predicted_match_provider.dart";
import 'package:bet_app/src/widgets/predicted_item_local.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PredictedMatchesLocal extends StatefulWidget {
  const PredictedMatchesLocal({super.key});

  @override
  State<PredictedMatchesLocal> createState() => _PredictedMatchesLocalState();
}

class _PredictedMatchesLocalState extends State<PredictedMatchesLocal> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final predictedMatchList =
        context.watch<PredictedMatchProvider>().predictedMatchList;
    return ListView.builder(
      controller: _scrollController,
      itemCount: predictedMatchList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(predictedMatchList[index]['matchId'].toString()),
          background: Container(
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              predictedMatchList.removeAt(index);
            });
          },
          child: PredictedItemLocal(predictedMatch: predictedMatchList[index]),
        );
      },
    );
  }
}
