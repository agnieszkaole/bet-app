import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/match_id_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextMatchScheduledItem extends StatefulWidget {
  const NextMatchScheduledItem({
    super.key,
    required this.match,
  });
  final SoccerMatch match;

  @override
  State<NextMatchScheduledItem> createState() => _NextMatchItemState();
}

class _NextMatchItemState extends State<NextMatchScheduledItem>
    with AutomaticKeepAliveClientMixin<NextMatchScheduledItem> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    int matchId = widget.match.fixture.id;
    var homeName = widget.match.home.name;
    var awayName = widget.match.away.name;
    var matchTime = widget.match.fixture.formattedDate;

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 41, 41, 41),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 0, 71, 33),
            Color.fromARGB(255, 1, 53, 26),
          ],
        ),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 0, 71, 32),
        ),
        // border: Border.all(
        //   width: 1,
        //   color: Color.fromARGB(255, 82, 82, 82),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            matchTime.toString(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          // Column(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   // crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           homeName,
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 12.0,
          //           ),
          //           overflow: TextOverflow.ellipsis,
          //           maxLines: 2,
          //         ),
          //       ],
          //     ),
          //     Text(
          //       "vs",
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 14,
          //       ),
          //     ),
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           awayName,
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 12,
          //           ),
          //           overflow: TextOverflow.ellipsis,
          //           maxLines: 2,
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
