import 'package:cloud_firestore/cloud_firestore.dart';

class Scoreboard {
  Future<void> updateScore(String groupId, String memberUid, int matchId, int scoreToAdd, String prediction) async {
    final groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final groupDoc = await transaction.get(groupRef);

        if (!groupDoc.exists) {
          print('Group document does not exist');
          return;
        }

        List<dynamic> membersData = groupDoc.data()?['members'] ?? [];

        int memberIndex =
            membersData.indexWhere((member) => member is Map<String, dynamic> && member['memberUid'] == memberUid);

        if (memberIndex == -1) {
          print('Member with UID $memberUid not found in group members data');
          return;
        }

        // Retrieve member's previous scores for the match
        List<dynamic> matchScores = membersData[memberIndex]['matchScores'] ?? [];
        bool scoreUpdated = matchScores.any((matchScore) => matchScore['matchId'] == matchId);

        // Update the member's total score only if not already updated for the match
        if (!scoreUpdated) {
          int currentScore = membersData[memberIndex]['totalScore'] ?? 0;
          int updatedScore = currentScore + scoreToAdd;

          membersData[memberIndex]['totalScore'] = updatedScore;

          // Add match score entry to prevent future duplicate updates
          matchScores.add({
            'matchId': matchId,
            'score': scoreToAdd,
          });

          membersData[memberIndex]['matchScores'] = matchScores;

          // Update the entire list of members with the modified member
          transaction.update(groupRef, {
            'members': membersData,
          });

          print('Firebase data updated successfully');
        } else {
          print('Score already updated for this match and member.');
        }
      });
    } catch (e) {
      print('Error updating member score and predictions: $e');
    }
  }
}
