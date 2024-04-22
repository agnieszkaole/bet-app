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

    var matchTime = widget.match.fixture.formattedDate;

    return Container(
      // width: 140,
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(25),
      //     color: Color.fromARGB(169, 41, 41, 41),
      //     border: Border.all(color: Color.fromARGB(255, 102, 102, 102), width: 0.4)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "./assets/images/football-157931_1280.png",
            width: 22,
          ),
          SizedBox(width: 5),
          Text(
            matchTime.toString(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
