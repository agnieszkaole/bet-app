import 'dart:convert';
// import 'package:bet_app/widgets/predicted_item.dart';
// import 'package:bet_app/widgets/predicted_list.dart';
import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PredictResult extends StatefulWidget {
  const PredictResult({
    super.key,
    required this.teamHomeName,
    required this.teamAwayName,
    required this.teamHomeLogo,
    required this.teamAwayLogo,
    required this.matchTime,
  });

  final String teamHomeName;
  final String teamAwayName;
  final String teamHomeLogo;
  final String teamAwayLogo;
  final String matchTime;

  @override
  State<PredictResult> createState() => _PredictResultItemState();
}

class _PredictResultItemState extends State<PredictResult> {
  int? _resultHome;
  int? _resultAway;
  final _formKey = GlobalKey<FormState>();

  void _saveResultPrediction() async {
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
            'Home': {
              "teamHomeName": widget.teamHomeName,
              "teamHomePrediction": _resultHome,
            },
            'Away': {
              "teamAwayName": widget.teamAwayName,
              "teamAwayPrediction": _resultAway,
            },
          },
        ),
      );

      if (!context.mounted) {
        return;
      }

      Provider.of<PredictedMatchProvider>(context, listen: false).addMatch(
        {
          'teamHomeName': widget.teamHomeName,
          'teamHomeLogo': widget.teamHomeLogo,
          'teamHomeGoal': _resultHome,
          'teamAwayName': widget.teamAwayName,
          'teamAwayLogo': widget.teamAwayLogo,
          'teamAwayGoal': _resultAway,
          'matchTime': widget.matchTime,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mecz został dodany'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          // decoration:
          //     const BoxDecoration(color: Color.fromARGB(255, 30, 9, 145)),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Podaj wynik',
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
                                  widget.teamHomeName,
                                  style: const TextStyle(fontSize: 17),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.teamHomeLogo,
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
                          child: TextFormField(
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
                                    color: Color.fromARGB(255, 40, 122, 43)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.greenAccent),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
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
                              _resultHome = int.parse(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        ":",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 80,
                          child: TextFormField(
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
                              _resultAway = int.parse(value!);
                            },
                          ),
                        ),
                        SizedBox(
                            width: 130,
                            height: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.teamAwayName,
                                  style: const TextStyle(fontSize: 17),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.teamAwayLogo,
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
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     OutlinedButton(
                //       onPressed: () {},
                //       style: OutlinedButton.styleFrom(
                //         foregroundColor: Color.fromARGB(255, 56, 179, 60),
                //         elevation: 15.0,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //       ),
                //       child: const Text('Zwycięstwo'),
                //     ),
                //     OutlinedButton(
                //       onPressed: () {},
                //       style: OutlinedButton.styleFrom(
                //         foregroundColor: Color.fromARGB(255, 56, 179, 60),
                //         elevation: 15.0,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //       ),
                //       child: const Text('Remis'),
                //     ),
                //     OutlinedButton(
                //       onPressed: () {},
                //       style: OutlinedButton.styleFrom(
                //         foregroundColor: Color.fromARGB(255, 56, 179, 60),
                //         elevation: 15.0,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //       ),
                //       child: const Text('Zwycięstwo'),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveResultPrediction,
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
