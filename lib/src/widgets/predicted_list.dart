import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/widgets/predicted_matches_firebase.dart';
import 'package:bet_app/src/widgets/predicted_matches_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bet_app/src/widgets/predicted_item_local.dart';
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
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  String dataFromChild = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      isAnonymous = user!.isAnonymous;
    });
  }

  @override
  Widget build(BuildContext context) {
    final predictedMatchList =
        context.watch<PredictedMatchProvider>().predictedMatchList;
    return
        // (predictedMatchList.isEmpty)
        //     ? const Center(
        //         child: Text(
        //           'Nie dodano żadnych zakładów.',
        //           style: TextStyle(fontSize: 20),
        //         ),
        //       )
        //     :
        Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Text(
          'Twoje wytypowane mecze',
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
            child: isAnonymous
                ? const PredictedMatchesLocal()
                : const PredictedMatchesFirebase(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
