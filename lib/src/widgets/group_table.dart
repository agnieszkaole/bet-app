import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/services/soccer_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GroupTable extends StatefulWidget {
  const GroupTable({super.key, this.leagueNumber, required this.createdAt});
  final String? leagueNumber;
  final Timestamp? createdAt;

  @override
  State<GroupTable> createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
  // static const int sortName = 0;
  // static const int sortStatus = 1;

  bool isAscending = true;
  // int sortType = sortName;
  List users = ['Maciej', 'Staś', 'Grzesiek', 'Krzysiek', 'Piotrek'];
  String? statusApi = 'ns-tbd-ft-aet-pen';
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

  void initData(int size) {
    for (int i = 0; i < size; i++) {
      users.add(users[i]);
    }
  }

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
              return const Center(
                child: Text(
                  'There are no data to display.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Scoreboard', style: TextStyle(fontSize: 22)),
                    SizedBox(height: 10),
                    _getBodyWidget(),
                  ],
                ),
              );
            }
          }
          return Container();
        });
  }

  Widget _getBodyWidget() {
    late List<SoccerMatch> scoreboardMatchesList = context.watch<ScoreboardProvider>().scoreboardMatchesList;
    // print(scoreboardMatchesList.length);
    NextMatchesProvider.sortMatchesByDate(scoreboardMatchesList);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 180,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: scoreboardMatchesList.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 1,
        ),
        leftHandSideColBackgroundColor: Color.fromARGB(255, 29, 29, 29),
        rightHandSideColBackgroundColor: Color.fromARGB(255, 54, 54, 54),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> titleWidgets = [];
    titleWidgets.add(_getTitleItemWidget('', 350, Colors.black45));
    for (String user in users) {
      titleWidgets.add(
        _getTitleItemWidget(user, 80, Color.fromARGB(255, 25, 124, 66)),
      );
    }

    return titleWidgets;
  }

  Widget _getTitleItemWidget(String label, double width, Color color) {
    return Container(
      decoration: BoxDecoration(color: color, border: Border.all(width: 0.5)),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
      ),
      width: width,
      height: 56,
      padding: EdgeInsets.all(5),
      // alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    late List<SoccerMatch> scoreboardMatchesList = context.watch<ScoreboardProvider>().scoreboardMatchesList;
    if (scoreboardMatchesList.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 46, 46, 46),
        ),
        height: 60,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
        child: Text(
          'No match found',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
    NextMatchesProvider.sortMatchesByDate(scoreboardMatchesList);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: scoreboardMatchesList.map((scoreboardMatch) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 46, 46, 46),
            border: Border.all(width: 0.5),
          ),
          height: 90,
          padding: const EdgeInsets.only(left: 8, right: 12, top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                scoreboardMatch.fixture.formattedDate,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${scoreboardMatch.home.name} ',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    '${scoreboardMatch.goal.home ?? '?'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${scoreboardMatch.away.name} ',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    '${scoreboardMatch.goal.away ?? '?'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Center(
            child: Text(
              'wynik',
              style: TextStyle(fontSize: 18),
            ),
          ),
          width: 80,
          height: 90,
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
