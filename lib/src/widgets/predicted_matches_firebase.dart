import "package:bet_app/src/widgets/predicted_item_firebase.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class PredictedMatchesFirebase extends StatefulWidget {
  const PredictedMatchesFirebase({super.key});

  @override
  State<PredictedMatchesFirebase> createState() =>
      _PredictedMatchesFirebaseState();
}

class _PredictedMatchesFirebaseState extends State<PredictedMatchesFirebase> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isAnonymous = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isAnonymous = user!.isAnonymous;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('matches')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<DocumentSnapshot> firestoreDocuments = snapshot.data!.docs;
          print('Document Count: ${firestoreDocuments.length}');

          return ListView.builder(
            itemCount: firestoreDocuments.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  firestoreDocuments[index].data() as Map<String, dynamic>;

              // String homeName = data['homeName'];
              // String awayName = data['awayName'];
              // int? homeGoal = data['homeGoal'];
              // int? awayGoal = data['awayGoal'];
              // String leagueName = data['leagueName'];
              // int matchId = data['matchId'];
              // String matchTime = data['matchTime'];
              print(data['homelogo']);

              return PredictedItemFirebase(data: data);
            },
          );
        }
      },
    );
  }
}
