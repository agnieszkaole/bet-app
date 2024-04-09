import "dart:async";

import "package:bet_app/src/provider/predicted_match_provider.dart";
import "package:bet_app/src/widgets/predicted_item_firebase.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PredictedMatchesFirebase extends StatefulWidget {
  const PredictedMatchesFirebase({super.key, required this.leagueNumber});
  final int? leagueNumber;

  @override
  State<PredictedMatchesFirebase> createState() => _PredictedMatchesFirebaseState();
}

class _PredictedMatchesFirebaseState extends State<PredictedMatchesFirebase> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isAnonymous = true;

  StreamSubscription<QuerySnapshot>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    setState(() {
      isAnonymous = user!.isAnonymous;
    });
    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('matches')
        .snapshots()
        .listen((snapshot) {});
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('predictions').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<DocumentSnapshot> firestoreDocuments = snapshot.data!.docs;
          print('Document Count: ${firestoreDocuments.length}');
          firestoreDocuments.sort((a, b) {
            DateTime aTime = _parseDate(a['matchTime'] as String);
            DateTime bTime = _parseDate(b['matchTime'] as String);
            return aTime.compareTo(bTime);
          });

          return ListView.builder(
            itemCount: firestoreDocuments.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userPrediction = firestoreDocuments[index].data() as Map<String, dynamic>;

              if (userPrediction['leagueNumber'] == widget.leagueNumber) {
                return Dismissible(
                  key: Key(userPrediction['matchId'].toString()),
                  background: Container(
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    Map<String, dynamic> deletedData = firestoreDocuments[index].data() as Map<String, dynamic>;
                    String documentId = firestoreDocuments[index].id;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('predictions')
                        .doc(documentId)
                        .delete();
                    setState(() {
                      firestoreDocuments.insert(index, deletedData as DocumentSnapshot<Object?>);
                    });
                  },
                  child: PredictedItemFirebase(data: userPrediction),
                );
              } else {
                return SizedBox();
              }
            },
          );
        }
      },
    );
  }

  DateTime _parseDate(String date) {
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
}
