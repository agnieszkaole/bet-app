import 'package:bet_app/src/models/league_standings.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/match_id_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StandingsItem extends StatefulWidget {
  const StandingsItem({
    super.key,
    required this.standings,
  });
  final LeagueStandings standings;

  @override
  State<StandingsItem> createState() => _StandingsItemState();
}

class _StandingsItemState extends State<StandingsItem> with AutomaticKeepAliveClientMixin<StandingsItem> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 41, 41, 41),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 62, 155, 19),
            Color.fromARGB(255, 31, 77, 10),
          ],
        ),
        // border: Border.all(
        //   width: 1,
        //   color: Color.fromARGB(255, 0, 71, 32),
        // ),
        // image: DecorationImage(image: AssetImage('./assets/images/lawn-5007569_1920.jpg'), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          widget.standings.toString(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
      ]),
    );
  }
}
