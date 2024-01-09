import 'dart:convert';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final formatter = DateFormat.yMd();

class PredictedResultEdith extends StatefulWidget {
  PredictedResultEdith({
    super.key,
    // required this.predictedMatch,
  });
  // Map<String, dynamic> predictedMatch;

  @override
  State<PredictedResultEdith> createState() => _PredictedResultEdithState();
}

class _PredictedResultEdithState extends State<PredictedResultEdith> {
  // final _titleController = TextEditingController();
  int? _resultHome;
  int? _resultAway;
  final _formKey = GlobalKey<FormState>();

  void _saveEdithResultPrediction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https(
          'bet-app-d8cec-default-rtdb.europe-west1.firebasedatabase.app',
          'result-prediction.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            // 'matchId': widget.matchId,
            'Home': {
              // "teamHomeName": widget.teamHomeName,
              "teamHomePrediction": _resultHome,
            },
            'Away': {
              // "teamAwayName": widget.teamAwayName,
              "teamAwayPrediction": _resultAway,
            },
          },
        ),
      );

      if (!context.mounted) {
        return;
      }
      final predictedMatchList =
          context.watch<PredictedMatchProvider>().predictedMatchList;

      for (var i = 0; i < predictedMatchList.length; i++) {
        Map<String, dynamic> predictedMatch = predictedMatchList[i];
        if (_resultHome != predictedMatch['teamHomeGoal'] ||
            _resultAway != predictedMatch['awayHomeGoal']) {
          Provider.of<PredictedMatchProvider>(context, listen: false).addMatch(
            {
              'teamHomeGoal': _resultHome,
              'teamAwayGoal': _resultAway,
              // 'matchId': widget.matchId
            },
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wynik został edytowany'),
        ),
      );
    }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const Text(
                  'Edytuj wynik',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 130,
                            // height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' widget.predictedMatch',
                                  style: const TextStyle(fontSize: 17),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: "fthfdh",
                                    fadeInDuration: Duration(milliseconds: 50),
                                    // placeholder: (context, url) =>
                                    //     const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    width: 45.0,
                                  ),
                                  // child: Image.network(
                                  //   widget.teamHomeLogo,
                                  //   width: 45.0,
                                  //   // height: 36.0,
                                  // ),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 40,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                autofocus: false,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '?',
                                  border: const OutlineInputBorder(),
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 40, 122, 43)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.greenAccent),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  ),
                                ),
                                initialValue: "",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Wpisz poprawną liczbę';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  // _resultHome = int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "-",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                autofocus: false,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '?',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 40, 122, 43),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.greenAccent,
                                      width: 2,
                                    ),
                                  ),
                                  // focusedErrorBorder: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(10),
                                  //   borderSide: const BorderSide(
                                  //     color: Colors.red,
                                  //     width: 2,
                                  //   ),
                                  // ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                initialValue: "",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Wpisz poprawn liczbę';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  // _resultAway = int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: 130,
                            height: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "fghfghfg",
                                  style: const TextStyle(fontSize: 17),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: "fghfghfghfgh",
                                    fadeInDuration: Duration(milliseconds: 50),
                                    // placeholder: (context, url) =>
                                    //     const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    width: 45.0,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveEdithResultPrediction,
                    // onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.white, //change background color of button
                      backgroundColor: const Color.fromARGB(
                          255, 40, 122, 43), //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text('Zapisz'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
