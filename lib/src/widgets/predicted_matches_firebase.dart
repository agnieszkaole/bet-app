import "package:bet_app/src/widgets/predicted_item_firebase.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class PredictedMatchesFirebase extends StatefulWidget {
  const PredictedMatchesFirebase({
    super.key,
    required this.leagueNumber,
    this.groupId,
  });
  final int? leagueNumber;
  final String? groupId;
  @override
  State<PredictedMatchesFirebase> createState() => _PredictedMatchesFirebaseState();
}

class _PredictedMatchesFirebaseState extends State<PredictedMatchesFirebase> {
  User? user = FirebaseAuth.instance.currentUser;
  // bool isAnonymous = true;

  // StreamSubscription<QuerySnapshot>? _streamSubscription;

  // @override
  // void initState() {
  // super.initState();
  // setState(() {
  //   isAnonymous = user!.isAnonymous;
  // });
  // _streamSubscription = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(user!.uid)
  //     .collection('matches')
  //     .snapshots()
  //     .listen((snapshot) {});
  // }

  // @override
  // void dispose() {
  //   // _streamSubscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.groupId);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('predictions')
          .where('leagueNumber', isEqualTo: widget.leagueNumber)
          .where('groupId', isEqualTo: widget.groupId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
        }
        if (snapshot.data!.docs.isEmpty) {
          return const SizedBox(
            height: 140,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have not added any predictions',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'or unexpected state encountered. ',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Please try again later.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          // if (snapshot.data != []) {
          List<DocumentSnapshot> firestoreDocuments = snapshot.data!.docs;
          print('Document Count: ${firestoreDocuments.length}');
          firestoreDocuments.sort((a, b) {
            DateTime aTime = _parseDate(a['matchTime'] as String);
            DateTime bTime = _parseDate(b['matchTime'] as String);
            return aTime.compareTo(bTime);
          });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: firestoreDocuments.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userPrediction = firestoreDocuments[index].data() as Map<String, dynamic>;

                    if (userPrediction['leagueNumber'] == widget.leagueNumber) {
                      String documentId = firestoreDocuments[index].id;
                      return PredictedItemFirebase(data: userPrediction, docId: documentId);
                    }
                    return Container();
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox(
          height: 140,
          child: Center(
            child: Text(
              'Unexpected state encountered. Please try again later.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        );
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
