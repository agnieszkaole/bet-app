import 'package:cloud_firestore/cloud_firestore.dart';

class Scoreboard {
  Map<String, List<int>> memberScores = {};

  Future<void> updateScore(
    String groupId,
    String memberUid,
    int matchId,
    int scoreToAdd,
  ) async {
    final groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

    void addScore(String memberUid, int score) {
      memberScores.putIfAbsent(memberUid, () => []);
      memberScores[memberUid]!.add(score);
    }

    int calculateTotalScore(String memberUid) {
      List<int> scores = memberScores[memberUid] ?? [];
      int totalScore = scores.fold(0, (total, score) => total + score);
      return totalScore;
    }

    try {
      // Fetch the current group data
      final groupDoc = await groupRef.get();
      if (!groupDoc.exists) {
        print('Group document does not exist');
        return;
      }

      // Extract members data from the document
      List<dynamic> membersData = groupDoc.data()?['members'] ?? [];

      dynamic memberToUpdate;
      for (int i = 0; i < membersData.length; i++) {
        dynamic member = membersData[i];
        if (member is Map<String, dynamic> && member['memberUid'] == memberUid) {
          memberToUpdate = member;
          break;
        }
      }

      if (memberToUpdate == null) {
        print('Member with UID $memberUid not found in group members data');
        return;
      }

      // Update the member's total score in the document data
      int currentScore = calculateTotalScore(memberUid);

      // print('Current Score for Member $memberUid: $currentScore');

      int updatedScore = currentScore + scoreToAdd;
      // print('Updated Score for Member $memberUid: $updatedScore');

      memberToUpdate['totalScore'] = updatedScore;

      // Record the new score for the member in the scoreboard map
      memberScores.putIfAbsent(memberUid, () => []);
      memberScores[memberUid]?.add(scoreToAdd);

      await groupRef.update({
        'members': memberToUpdate,
      });
      addScore(memberUid, scoreToAdd);
      // print(calculateTotalScore('y9pZ3wmiAzVOEgSl4BWsRrlnl2N2'));
      print('Firebase data updated successfully');
    } catch (e, stackTrace) {
      print('Error updating member score and predictions: $e');
    }
  }
}
