import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/widgets/predicted_result_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictedItemFirebase extends StatefulWidget {
  PredictedItemFirebase({
    required this.data,
    required this.docId,
    super.key,
  });

  late Map<String, dynamic> data;
  String docId;

  @override
  State<PredictedItemFirebase> createState() => _PredictedItemFirebaseState();
}

class _PredictedItemFirebaseState extends State<PredictedItemFirebase> {
  bool isNewMatch = true;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    String homeName = widget.data['homeName'] ?? '';
    String awayName = widget.data['awayName'] ?? '';
    String homeLogo = widget.data['homeLogo'] ?? '';
    String awayLogo = widget.data['awayLogo'] ?? '';
    int homeGoal = widget.data['homeGoal'] ?? 0;
    int awayGoal = widget.data['awayGoal'] ?? 0;
    // String leagueName = widget.data['leagueName'] ?? '';
    int matchId = widget.data['matchId'] ?? 0;
    String matchTime = widget.data['matchTime'] ?? '';

    DateTime parseDate(String date) {
      final parts = date.split(' - ');
      final datePart = parts[0];
      final timePart = parts[1];
      final dateParts = datePart.split('.');
      final timeParts = timePart.split(':');

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    }

    DateTime matchDateTime = parseDate(matchTime);
    Duration timeDifference = matchDateTime.difference(DateTime.now()); // Calculate time difference correctly
    bool isWithinXHours = timeDifference.inMinutes <= 0;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Color.fromARGB(207, 32, 32, 32),
            border: Border.all(color: Color.fromARGB(255, 102, 102, 102), width: 0.4)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      matchTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        homeName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CachedNetworkImage(
                        imageUrl: homeLogo,
                        fadeInDuration: const Duration(milliseconds: 50),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        width: 30.0,
                        // height: 30.0,
                      ),

                      //  Image.network(
                      //   homeLogo,
                      //   width: 36.0,
                      // height: 36.0,
                      // ),
                    ),
                    Expanded(
                      child: Text(
                        "$homeGoal - $awayGoal",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CachedNetworkImage(
                        imageUrl: awayLogo,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        width: 30.0,
                        // height: 30.0,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        awayName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isWithinXHours == false)
              Positioned(
                right: 0.0,
                top: 0.0,
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      shape: const StadiumBorder(),
                      side: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(90, 66, 201, 70),
                      ),
                      // side: BorderSide.none,
                      foregroundColor:
                          // const Color.fromARGB(255, 176, 206, 177),
                          Color.fromARGB(255, 66, 201, 70),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PredictedResultEdit(
                          teamHomeName: homeName,
                          teamAwayName: awayName,
                          teamHomeLogo: homeLogo,
                          teamAwayLogo: awayLogo,
                          matchId: matchId,
                        ),
                      ));
                    },
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.edit_note_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 0.0,
              top: 0.0,
              child: SizedBox(
                width: 35,
                height: 35,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 224, 20, 20),
                    ),
                    // side: BorderSide.none,
                    foregroundColor:
                        // const Color.fromARGB(255, 176, 206, 177),
                        Color.fromARGB(255, 66, 201, 70),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text(
                                'Delete match prediction',
                                style: TextStyle(fontSize: 18),
                              ),
                              content: Text('Are you sure you want to delete this prediction? '),
                              actions: [
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Color.fromARGB(255, 255, 1, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(color: Color.fromARGB(255, 255, 1, 1)),
                                    ),
                                  ),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .collection('predictions')
                                        .doc(widget.docId)
                                        .delete()
                                        .then((value) {
                                      if (mounted) {
                                        setState(() {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(content: Text('Prediced match deleted.')));
                                        });
                                      }
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 2, 126, 6),
                                      foregroundColor: Color.fromARGB(255, 255, 255, 255)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]);
                        });
                  },
                  child: const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      color: Color.fromARGB(255, 224, 20, 20),
                      Icons.delete_rounded,
                      size: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// DateTime _parseDate(String date) {
//   final parts = date.split(' - ');
//   final datePart = parts[0];
//   final timePart = parts[1];
//   final dateParts = datePart.split('.');
//   final timeParts = timePart.split(':');

//   final day = int.parse(dateParts[0]);
//   final month = int.parse(dateParts[1]);
//   final year = int.parse(dateParts[2]);
//   final hour = int.parse(timeParts[0]);
//   final minute = int.parse(timeParts[1]);

//   return DateTime(year, month, day, hour, minute);
// }
