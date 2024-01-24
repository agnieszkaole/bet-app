import "dart:async";

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
        .listen((snapshot) {
      // Handle the snapshot
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
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

              return Dismissible(
                  key: Key(data['matchId'].toString()),
                  background: Container(
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    Map<String, dynamic> deletedData = firestoreDocuments[index]
                        .data() as Map<String, dynamic>;
                    String documentId = firestoreDocuments[index].id;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('matches')
                        .doc(documentId)
                        .delete();
                    setState(() {
                      firestoreDocuments.insert(
                          index, deletedData as DocumentSnapshot<Object?>);
                    });
                  },
                  child: PredictedItemFirebase(data: data));
            },
          );
        }
      },
    );
  }
}
