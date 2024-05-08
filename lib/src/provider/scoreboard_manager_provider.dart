// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ScoreboardManagerProvider extends ChangeNotifier {
//   // Define memberPredictions as a map where groupId maps to a list of predictions
//   Map<String, List<Map<String, dynamic>>> memberPredictions = {};

//   void addOrUpdatePrediction(
//     String groupId,
//     String memberUid,
//     int matchId,
//     String prediction,
//     int scoreToAdd,
//   ) {
//     // Ensure the groupId has an initialized list for predictions
//     memberPredictions.putIfAbsent(groupId, () => []);

//     // Remove any existing prediction for the same memberUid and matchId
//     memberPredictions[groupId]
//         ?.removeWhere((prediction) => prediction['memberUid'] == memberUid && prediction['matchId'] == matchId);

//     // Add the new prediction to the list
//     memberPredictions[groupId]?.add({
//       'memberUid': memberUid,
//       'matchId': matchId,
//       'prediction': prediction,
//     });

//     // Recalculate scores after updating predictions
//     _recalculateScores(groupId, scoreToAdd);
//   }

//   void _recalculateScores(String groupId, int scoreToAdd) {
//     List<Map<String, dynamic>> predictions = memberPredictions[groupId] ?? [];

//     for (var prediction in predictions) {
//       String memberUid = prediction['memberUid'];
//       String predictedScore = prediction['prediction'];

//       // Fetch member data from Firebase and update score
//       updateMemberScore(groupId, memberUid, calculateScore(predictedScore, scoreToAdd));
//     }
//   }

//   Future<void> updateMemberScore(String groupId, String memberUid, int newScore) async {
//     final groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

//     try {
//       final groupDoc = await groupRef.get();
//       if (groupDoc.exists) {
//         List<dynamic> membersData = groupDoc.data()?['members'] ?? [];

//         // Update the totalScore for the specified memberUid
//         for (int i = 0; i < membersData.length; i++) {
//           dynamic member = membersData[i];
//           if (member is Map<String, dynamic> && member['memberUid'] == memberUid) {
//             int currentScore = member['totalScore'] ?? 0;
//             int updatedScore = currentScore + newScore;

//             member['totalScore'] = updatedScore;
//             await groupRef.update({'members': membersData});
//             print('Updated totalScore for Member: $memberUid to $updatedScore');
//             return;
//           }
//         }
//         print('Member with UID $memberUid not found in group members data');
//       } else {
//         print('Group document does not exist');
//       }
//     } catch (e) {
//       print('Error updating member score: $e');
//     }
//   }

//   int calculateScore(String predictedScore, int scoreToAdd) {
//     // Implement your score calculation logic based on predictedScore if needed
//     // For example, you might parse the predictedScore string to calculate a score
//     // Here, we're simply returning the scoreToAdd value
//     return scoreToAdd;
//   }
// }
