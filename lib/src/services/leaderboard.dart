import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  Future<void> addScores(String memberUid, int score) async {
    try {
      if (memberUid.isEmpty) {
        throw ArgumentError('User ID cannot be null or empty');
      }

      final userDocRef = FirebaseFirestore.instance.collection('users').doc(memberUid);

      final scoringCollectionRef = userDocRef.collection('scoring');
      final scoringDocRef = scoringCollectionRef.doc('score');

      final scoringSnapshot = await scoringDocRef.get();
      if (!scoringSnapshot.exists) {
        await scoringDocRef.set({'score': 0});
        print('Initial score set to 0 for memberUid: $memberUid');
      }
      await scoringDocRef.update({'score': FieldValue.increment(score)});

      print('Score added successfully for userId: $memberUid');
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
