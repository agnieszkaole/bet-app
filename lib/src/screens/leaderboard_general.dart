import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardGeneral extends StatefulWidget {
  const LeaderboardGeneral({super.key});

  @override
  State<LeaderboardGeneral> createState() => _LeaderboardGeneralState();
}

class _LeaderboardGeneralState extends State<LeaderboardGeneral> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('groups').doc('selectedGroupId').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for data, show a loading indicator
                return Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                // If an error occurs, display the error message
                final error = snapshot.error;
                return Center(
                  child: Text(
                    '$error',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              }

              if (snapshot.hasData) {
                final members = snapshot.data!.data()?['members'] as List<dynamic>?;

                if (members != null && members.isNotEmpty) {
                  members.sort((a, b) {
                    final int scoreA = a['score'] ?? 0;
                    final int scoreB = b['score'] ?? 0;
                    return scoreB.compareTo(scoreA);
                  });
                  return ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      // Extract member details from each member object
                      final member = members[index] as Map<String, dynamic>;
                      // final memberUid = member['memberUid'] as String;
                      final memberUsername = member['memberUsername'] as String;
                      final score = member['score'] as int?;

                      final rankingOrder = index + 1;

                      return Column(
                        children: [
                          ListTile(
                            leading: Text('$rankingOrder'),
                            title: Text('$memberUsername'),
                            trailing: Text('${score ?? '0'}'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // If 'members' array is empty or not available, display a message
                  return Center(
                    child: Text(
                      'Select a group to see leaderboard',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              }

              // If none of the above conditions are met, display a generic error message
              return Center(
                child: Text(
                  'Unexpected state encountered. Please try again later.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}





// Column(
//                         children: [
//                           ListTile(
//                             leading: Text('$rankingOrder'),
//                             title: Text('$memberUsername'),
//                             trailing: Text('${score ?? '0'}'),
//                           ),
//                         ],
//                       );