import 'dart:convert';
// import 'package:bet_app/widgets/predicted_item.dart';
// import 'package:bet_app/widgets/predicted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PredictResultItem extends StatefulWidget {
  const PredictResultItem({
    super.key,
    required this.teamPrediction1,
    required this.teamPrediction2,
  });

  final String teamPrediction1;
  final String teamPrediction2;

  @override
  State<PredictResultItem> createState() => _PredictResultItemState();
}

class _PredictResultItemState extends State<PredictResultItem> {
  int? _result1;
  int? _result2;

  final _formKey = GlobalKey<FormState>();

  // var _isSending = false;

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
            'prediction1': {
              "team1": widget.teamPrediction1,
              "result1": _result1,
            },
            'prediction2': {
              "team2": widget.teamPrediction2,
              "result2": _result2,
            },
          },
        ),
      );
      // final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(());

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const PredictedItem(
      //         // teamPrediction1: team1,
      //         // teamPrediction2: team2,
      //         ),
      //   ),
      // );

      // var headers = {
      //   'x-rapidapi-key': '210d8f8075e74dbbfc3f783d1b574c19',
      //   'x-rapidapi-host': 'v3.football.api-sports.io'
      // };
      // var request = http.Request('GET',
      //     Uri.parse('https://v3.football.api-sports.io/teams?name=poland'));

      // request.headers.addAll(headers);

      // http.StreamedResponse response1 = await request.send();

      // if (response.statusCode == 200) {
      //   print(await response1.stream.bytesToString());
      // } else {
      //   print(response.reasonPhrase);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        // decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 9, 145)),
        child: Form(
          key: _formKey,
          child: Column(
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
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.teamPrediction1,
                                style: const TextStyle(fontSize: 17),
                                softWrap: true,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.sports_soccer,
                                  size: 40,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 40,
                        height: 60,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              hintText: '?',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.zero),
                          initialValue: "",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wpisz poprawną liczbę';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _result1 = int.parse(value!);
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
                        height: 60,
                        child: SizedBox(
                          width: 40,
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                            ],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.zero,
                              hintText: '?',
                            ),
                            initialValue: "",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Wpisz poprawn liczbę';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _result2 = int.parse(value!);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 130,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.teamPrediction2,
                                style: const TextStyle(fontSize: 17),
                                softWrap: true,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.sports_soccer,
                                  size: 40,
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
    );
  }
}
