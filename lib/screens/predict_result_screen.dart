import 'package:bet_app/widgets/predict_result_item.dart';
import "package:flutter/material.dart";

class PredictResultScreen extends StatelessWidget {
  const PredictResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const PredictResultItem(
        teamPrediction1: '',
        teamPrediction2: '',
      ),
      // body: ListView(
      //   children: const [
      //     Padding(
      //       padding: EdgeInsets.all(10),
      //       child: Text(
      //         'Jaki będzie wynik?',
      //         style: TextStyle(fontSize: 25),
      //         textAlign: TextAlign.center,
      //       ),
      //     ),

      // ],
    );
  }
}
