import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/widgets/predicted_result_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictedItemFirebase extends StatefulWidget {
  PredictedItemFirebase({
    required this.data,
    required this.docId,
    required this.matchId,
    super.key,
  });

  late final Map<String, dynamic> data;
  final String docId;
  final int? matchId;

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
    Duration timeDifference = matchDateTime.difference(DateTime.now());
    bool isWithinXHours = timeDifference.inMinutes <= 0;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        // height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(70, 49, 49, 49),
          border: Border.all(
            width: .5,
            color: const Color.fromARGB(192, 145, 145, 145),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Your bet:',
                  ),
                  Text(
                    "$homeGoal - $awayGoal",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: SizedBox(
                width: 35,
                height: 35,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 129, 129, 129),
                    ),
                    // side: BorderSide.none,
                    foregroundColor:
                        // const Color.fromARGB(255, 176, 206, 177),
                        const Color.fromARGB(255, 129, 129, 129),
                  ),
                  onPressed: () {
                    showDialog(
                        barrierColor: const Color.fromARGB(167, 9, 11, 29),
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: AppColors.green),
                                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
                              title: const Text(
                                'Edition unavailable',
                                style: TextStyle(fontSize: 18),
                              ),
                              content: const Text("The bet can only be edited until the match starts.",
                                  style: TextStyle(fontSize: 14)),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 2, 126, 6),
                                      foregroundColor: const Color.fromARGB(255, 255, 255, 255)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Ok',
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
                      Icons.edit_note_rounded,
                      size: 24,
                    ),
                  ),
                ),
              ),
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
                      padding: const EdgeInsets.all(0),
                      shape: const StadiumBorder(),
                      side: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(90, 66, 201, 70),
                      ),
                      // side: BorderSide.none,
                      foregroundColor:
                          // const Color.fromARGB(255, 176, 206, 177),
                          const Color.fromARGB(255, 66, 201, 70),
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
                    padding: const EdgeInsets.all(0),
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 224, 20, 20),
                    ),
                    // side: BorderSide.none,
                    foregroundColor:
                        // const Color.fromARGB(255, 176, 206, 177),
                        const Color.fromARGB(255, 66, 201, 70),
                  ),
                  onPressed: () {
                    showDialog(
                        barrierColor: const Color.fromARGB(167, 9, 11, 29),
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(color: AppColors.green),
                                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
                              title: const Text(
                                'Delete bet',
                                style: TextStyle(fontSize: 18),
                              ),
                              content: const Text('Are you sure you want to delete this bet? '),
                              actions: [
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(255, 255, 1, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: const BorderSide(color: Color.fromARGB(255, 255, 1, 1)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
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
                                              .showSnackBar(const SnackBar(content: Text('Prediced match deleted.')));
                                        });
                                      }
                                    });
                                    Provider.of<PredictedMatchProvider>(context, listen: false).removeMatch(matchId);
                                    // print(
                                    //     Provider.of<PredictedMatchProvider>(context, listen: false).predictedMatchList);
                                    setState(() {});
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
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.greenDark,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: const BorderSide(width: 1, color: AppColors.greenDark),
                                    ),
                                    // elevation: 4.0,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      color: AppColors.green,
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
