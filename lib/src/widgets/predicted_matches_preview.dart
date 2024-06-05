import "package:bet_app/src/provider/predicted_match_provider.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

// class PredictedMatchesPreview extends StatefulWidget {
//   const PredictedMatchesPreview({
//     super.key,
//     required this.leagueNumber,
//     this.groupId,
//     this.matchId,
//   });
//   final int? leagueNumber;
//   final String? groupId;
//   final int? matchId;

//   @override
//   State<PredictedMatchesPreview> createState() => _PredictedMatchesPreviewState();
// }

// class _PredictedMatchesPreviewState extends State<PredictedMatchesPreview> {
//   User? user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .collection('predictions')
//             .where('leagueNumber', isEqualTo: widget.leagueNumber)
//             .where('groupId', isEqualTo: widget.groupId)
//             .where('matchId', isEqualTo: widget.matchId)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }

//           if (snapshot.hasError) {
//             final error = snapshot.error;

//             return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
//           }
//           // if (!snapshot.hasData) {
//           //   return const SizedBox(
//           //     height: 140,
//           //     child: Center(
//           //       child: Column(
//           //         mainAxisAlignment: MainAxisAlignment.center,
//           //         children: [
//           //           Text(
//           //             'You have not added any predictions',
//           //             style: TextStyle(fontSize: 16),
//           //             textAlign: TextAlign.center,
//           //           ),
//           //           Text(
//           //             'or unexpected state encountered.',
//           //             style: TextStyle(fontSize: 16),
//           //             textAlign: TextAlign.center,
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   );
//           // }
//           // if (!snapshot.hasData) {
//           //   return Container(
//           //     height: 40,
//           //     width: 180,
//           //     margin: EdgeInsets.all(10),
//           //     child: ElevatedButton(
//           //       onPressed: null,
//           //       style: OutlinedButton.styleFrom(
//           //         foregroundColor: Colors.white,
//           //         // backgroundColor: const Color.fromARGB(255, 40, 122, 43),
//           //         shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(25),
//           //         ),
//           //         elevation: 3.0,
//           //       ),
//           //       child: const Text('Predict the result'),
//           //     ),
//           //   );
//           // }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No predictions found for this match.',
//                 style: TextStyle(fontSize: 20),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           }

//           if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//             List<DocumentSnapshot> firestoreDocuments = snapshot.data!.docs;
//             return SizedBox(
//               height: 70,
//               child: ListView.builder(
//                 itemCount: firestoreDocuments.length,
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> userPrediction = firestoreDocuments[index].data() as Map<String, dynamic>;
//                   int homeGoal = userPrediction['homeGoal'];
//                   int awayGoal = userPrediction['awayGoal'];

//                   return Column(
//                     children: [
//                       Divider(
//                         height: 20,
//                         thickness: 2,
//                         endIndent: 10,
//                         indent: 10,
//                       ),
//                       Text('Your bet'),
//                       SizedBox(height: 5),
//                       Container(
//                         constraints: BoxConstraints(maxWidth: 160),
//                         // height: 100,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text(
//                               "$homeGoal",
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18.0,
//                               ),
//                             ),
//                             Text(
//                               ":",
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18.0,
//                               ),
//                             ),
//                             Text(
//                               "$awayGoal",
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18.0,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           }

//           return const SizedBox(
//             height: 140,
//             child: Center(
//               child: Text(
//                 'Unexpected state encountered. Please try again later.',
//                 style: TextStyle(fontSize: 20),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         });
//   }
// }

class PredictedMatchesPreview extends StatefulWidget {
  const PredictedMatchesPreview({
    Key? key,
    required this.leagueNumber,
    this.groupId,
    this.matchId,
  }) : super(key: key);

  final int? leagueNumber;
  final String? groupId;
  final int? matchId;

  @override
  State<PredictedMatchesPreview> createState() => _PredictedMatchesPreviewState();
}

class _PredictedMatchesPreviewState extends State<PredictedMatchesPreview> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PredictedMatchProvider>(
      builder: (context, predictedMatchProvider, _) {
        // Get the predicted matches list from the provider
        final predictedMatches = predictedMatchProvider.showMatchesByLeague(widget.leagueNumber);

        if (predictedMatches.isEmpty) {
          return Center(
            child: Text(
              'No predictions found for this match.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        }

        return SizedBox(
          height: 70,
          child: ListView.builder(
            itemCount: predictedMatches.length,
            itemBuilder: (context, index) {
              final userPrediction = predictedMatches[index];
              final homeGoal = userPrediction['homeGoal'] as int;
              final awayGoal = userPrediction['awayGoal'] as int;

              return Column(
                children: [
                  Divider(
                    height: 20,
                    thickness: 2,
                    endIndent: 10,
                    indent: 10,
                  ),
                  Text('Your bet'),
                  SizedBox(height: 5),
                  Container(
                    constraints: BoxConstraints(maxWidth: 160),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "$homeGoal",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          ":",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          "$awayGoal",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
