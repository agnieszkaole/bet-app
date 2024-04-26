import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:bet_app/src/widgets/custem_data_table.dart';
// import 'package:bet_app/src/widgets/selectable_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GroupTable extends StatefulWidget {
  const GroupTable({
    super.key,
    this.leagueNumber,
    required this.createdAt,
    this.groupId,
  });
  final String? leagueNumber;
  final Timestamp? createdAt;
  final String? groupId;

  @override
  State<GroupTable> createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
  // static const int sortName = 0;
  // static const int sortStatus = 1;

  bool isAscending = true;
  // int sortType = sortName;
  // List users = ['User 1', 'User 2', 'User 3', 'User 4', 'User 5'];
  String? statusApi = 'ns-tbd-ft-aet-pen-1H-HT-2H-ET-BT-P-SUSP-INT';
  // String? statusApi = '';
  String? timezoneApi = 'Europe/Warsaw';
  late DateTime createdAtDate;
  // DateTime dateTime = DateTime.parse(createdAtDate);
  String? formattedCreatedAtDate;
  String? formattedCreatedAtDateEnd;
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    createdAtDate = widget.createdAt!.toDate();
    _formatDate();
    dataFuture = _getData();
  }

  void _formatDate() {
    createdAtDate = widget.createdAt!.toDate();
    formattedCreatedAtDate = DateFormat('yyyy-MM-dd').format(createdAtDate);
    DateTime newDate = createdAtDate.add(Duration(days: 365 * 2));
    formattedCreatedAtDateEnd = DateFormat('yyyy-MM-dd').format(newDate);
  }

  Future<List<SoccerMatch>> _getData() async {
    final season1Data = await SoccerApi().getMatches('',
        league: widget.leagueNumber,
        season: '2023',
        from: formattedCreatedAtDate,
        to: formattedCreatedAtDateEnd,
        status: statusApi,
        timezone: timezoneApi);
    final season2Data = await SoccerApi().getMatches('',
        league: widget.leagueNumber,
        season: '2024',
        from: formattedCreatedAtDate,
        to: formattedCreatedAtDateEnd,
        status: statusApi,
        timezone: timezoneApi);

    List<SoccerMatch> mergedData = [];

    mergedData.addAll(season1Data);
    mergedData.addAll(season2Data);

    Provider.of<ScoreboardProvider>(context, listen: false).saveMatches(mergedData);

    return mergedData;
  }

  // void initData(int size) {
  //   for (int i = 0; i < size; i++) {
  //     users.add(users[i]);
  //   }
  // }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dataFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text('$error', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20));
            } else if (snapshot.data!.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Unexpected error occured.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Cannot display scoreboard.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Text("Compare predictions.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                      Text(
                          "Your prediction will be displayed when the match starts, so no one will be able to see your bet until prediciton time ends.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18)),
                      Text(
                          "If you are not sure whether you have predicted the result of the match, check the Predicted tab.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      DataTablePage(groupId: widget.groupId),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }
          }
          return Container();
        });
  }
}
