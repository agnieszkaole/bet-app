import 'dart:convert';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final formatter = DateFormat.yMd();

class PredictedResultEdit extends StatefulWidget {
  const PredictedResultEdit({
    super.key,
    required this.teamHomeName,
    required this.teamHomeLogo,
    required this.teamAwayName,
    required this.teamAwayLogo,
    required this.matchId,
  });
  final String teamHomeName;
  final String teamHomeLogo;
  final String teamAwayName;
  final String teamAwayLogo;
  final int matchId;

  @override
  State<PredictedResultEdit> createState() => _PredictedResultEdithState();
}

class _PredictedResultEdithState extends State<PredictedResultEdit> {
  // final _titleController = TextEditingController();
  late int _resultHome;
  late int _resultAway;
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      isAnonymous = user!.isAnonymous;
    });
  }

  Future<void> updatePredictedMatch(int? _resultHome, int? _resultAway) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not authenticated');
        return;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('predictions')
          .where('matchId', isEqualTo: widget.matchId)
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.update({
          'homeGoal': _resultHome,
          'awayGoal': _resultAway,
        });
      }

      print('Predicted match edithed in Firestore for the user');
    } catch (e) {
      print('Error edithind predicted match: $e');
    }
  }

  // void edithResult(int newResultHome, int newResultAway) {
  //   setState(() {
  //     _resultHome = newResultHome;
  //     _resultAway = newResultAway;
  //   });
  // }

  Future<void> _saveEdithResultPrediction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!context.mounted) {
        return;
      }

      if (!isAnonymous) {
        updatePredictedMatch(_resultHome, _resultAway);
      } else {
        Provider.of<PredictedMatchProvider>(context, listen: false)
            .updateMatchResult(widget.matchId, _resultHome, _resultAway);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // late List<Map<String, dynamic>> predictedMatchList =
    //     context.read<PredictedMatchProvider>().predictedMatchList;
    // Map<String, dynamic> predictedMatch = {};
    // for (var i = 0; i < predictedMatchList.length; i++) {
    //   predictedMatch = predictedMatchList[i];
    // }

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
                  'Edit result',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 130,
                            height: 150,
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
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.teamHomeLogo,
                                    fadeInDuration: Duration(milliseconds: 50),
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                autofocus: false,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '?',
                                  errorStyle: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.0,
                                    height: 0,
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.greenAccent),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.red),
                                  ),
                                ),
                                initialValue: "",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _resultHome = int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
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
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                autofocus: false,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '?',
                                  errorStyle: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.0,
                                    height: 0,
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.greenAccent),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.red),
                                  ),
                                ),
                                initialValue: "",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _resultAway = int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: 130,
                            height: 150,
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
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.teamAwayLogo,
                                    fadeInDuration: Duration(milliseconds: 50),
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
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
                  width: 280,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveEdithResultPrediction();
                    },
                    // onPressed: () {
                    // print();
                    // },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, //change background color of button
                      backgroundColor: const Color.fromARGB(255, 40, 122, 43), //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text('Save'),
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
