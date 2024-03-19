import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  Future<void> addScores(String userId, int score) async {
    try {
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be null or empty');
      }

      final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

      final scoringCollectionRef = userDocRef.collection('scoring');
      final scoringDocRef = scoringCollectionRef.doc('userScores');

      final scoringSnapshot = await scoringDocRef.get();
      if (!scoringSnapshot.exists) {
        await scoringDocRef.set({'score': 0});
        print('Initial score set to 0 for userId: $userId');
      }
      await scoringDocRef.update({'score': FieldValue.increment(score)});

      print('Score added successfully for userId: $userId');
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
