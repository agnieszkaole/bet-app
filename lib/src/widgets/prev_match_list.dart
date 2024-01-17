import 'package:bet_app/src/widgets/prev_match_item.dart';
import 'package:flutter/material.dart';

Widget prevMatchList(List allmatches) {
  return Column(
    children: [
      Expanded(
        // flex: 5,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            itemCount: allmatches.length,
            itemBuilder: (context, index) {
              return PrevMatchItem(match: allmatches[index]);
            },
          ),
        ),
      )
    ],
  );
}

// Widget MatchList(List allmatches) {

// }


      // Expanded(
      //   flex: 2,
      //   child: Container(
      //     child: Padding(
      //       padding:
      //           const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           teamStat("Local Team", allmatches[0].home.logoUrl,
      //               allmatches[0].home.name),
      //           goalStat(allmatches[0].fixture.status.elapsedTime,
      //               allmatches[0].goal.home, allmatches[0].goal.away),
      //           teamStat("Visitor Team", allmatches[0].away.logoUrl,
      //               allmatches[0].away.name),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),