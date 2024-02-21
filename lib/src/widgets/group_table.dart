import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/prev_matches_provider.dart';
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
  static const int sortName = 0;
  static const int sortStatus = 1;

  bool isAscending = true;
  int sortType = sortName;
  List users = ['Maciej', 'Staś', 'Grzesiek', 'Krzysiek', 'Piotrek'];
  // String? statusApi = 'ns-tbd-ft-aet-pen';
  String? statusApi = '';
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
    dataFuture = _getData();
    _formatDate();
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

    Provider.of<PrevMatchesProvider>(context, listen: false).saveMatches(mergedData);

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
    late List<SoccerMatch> prevMatchesList = context.watch<PrevMatchesProvider>().prevMatchesList;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 180,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        // isFixedFooter: true,
        // footerWidgets: [
        //   Text('hgjghjg'),
        //   Text('hgjghjg'),
        // ],
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: prevMatchesList.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 0.5,
          thickness: 0.0,
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
        _getTitleItemWidget(user, 80, const Color.fromARGB(255, 0, 155, 64)),
      );
    }

    return titleWidgets;
  }

  Widget _getTitleItemWidget(String label, double width, Color color) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      // alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
    if (nextMatchesList.isEmpty) {
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
    // final nextMatchesListSorted =
    //     NextMatchesProvider.sortMatchesByDate(nextMatchesList);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: nextMatchesList.map((nextMatch) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 46, 46, 46),
          ),
          height: 100,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nextMatch.home.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    ' vs ',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    nextMatch.away.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              // Text(
              //   '${nextMatch.goal.home} : ${nextMatch.goal.home}',
              //   style: const TextStyle(fontSize: 16),
              // ),
              Text(
                '? : ?',
                style: const TextStyle(fontSize: 16),
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
          height: 100,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
