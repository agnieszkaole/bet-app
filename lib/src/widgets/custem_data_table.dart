import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key, required this.groupId});
  final String? groupId;

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  List<Map<String, String>> _fixedRowCells = [];
  List _rowsCells = [];
  Groups groups = Groups();
  UserData userData = UserData();
  List<String>? memberUids;
  List<String> memberUsernames = [];
  List<Map<String, dynamic>>? matchesResult;
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.delayed(Duration(milliseconds: 200));
    await loadMemberList();
    await loadPredictedResultsByLeague();
  }

  Future<void> loadMemberList() async {
    try {
      Map<String, dynamic> groupData = await groups.getDataAboutGroup(widget.groupId);
      List<dynamic> members = groupData['members'] ?? [];
      List<Map<String, String>> memberInfoList = members.map((member) {
        final memberUsername = member['memberUsername'] != null ? member['memberUsername'].toString() : '';
        final memberUid = member['memberUid'] != null ? member['memberUid'].toString() : '';

        return {
          'memberUsername': memberUsername,
          'memberUid': memberUid,
        };
      }).toList();

      setState(() {
        memberUsernames = memberInfoList.map((memberInfo) => memberInfo['memberUsername']!).toList();
        memberUids = memberInfoList.map((memberInfo) => memberInfo['memberUid']!).toList();
        _fixedRowCells = memberInfoList;
      });
      // print(memberInfoList);
    } catch (error) {
      print('Error fetching member list: $error');
    }
  }

  Future<void> loadPredictedResultsByLeague() async {
    try {
      final scoreboardMatchesList = Provider.of<ScoreboardProvider>(context, listen: false).scoreboardMatchesList;
      final getLeague = await groups.getDataAboutGroup(widget.groupId);
      final selectedLeague = getLeague['selectedLeague']['leagueNumber'];
      final convertedMatches = [];
      // Map<String, List<Map<String, dynamic>>> predictionsByMember = {};

      if (memberUids != null) {
        for (var memberUid in memberUids!) {
          List<Map<String, dynamic>>? memberPredictions =
              await userData.getMatchesResultsForUser(memberUid, selectedLeague);

          if (memberPredictions != null) {
            for (var match in memberPredictions) {
              int matchId = match['matchId'];
              String prediction = "${match['homeGoal']} : ${match['awayGoal']}";

              try {
                var scoreboardMatch = scoreboardMatchesList.where(
                  (scoreboardMatch) => scoreboardMatch.fixture.id == matchId,
                );

                if (scoreboardMatch.isNotEmpty) {
                  convertedMatches.add({
                    'memberUid': memberUid,
                    'matchId': matchId,
                    'prediction': prediction,
                  });

                  // Add prediction to the map organized by memberUid
                  // predictionsByMember.putIfAbsent(memberUid, () => []);
                  // predictionsByMember[memberUid]!.add({
                  //   'matchId': matchId,
                  //   'prediction': prediction,
                  // });
                }
              } catch (e) {
                print('No match found for matchId $matchId');
              }
            }
          }
        }
      }

      setState(() {
        _rowsCells = convertedMatches;
      });
    } catch (error) {
      print('Error loading predicted results: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SizedBox(
            height: 500,
            child: CustomDataTable(
              fixedCornerCell: '',
              rowsCells: _rowsCells,
              fixedRowCells: _fixedRowCells,
              memberUsernames: memberUsernames,
            ),
          );
        }
      },
    );
  }
}

////////////////////////////

class CustomDataTable<T> extends StatefulWidget {
  final T fixedCornerCell;
  // final List<T> fixedColCells;
  final List<Map<String, String>> fixedRowCells;
  // final List<List<String>> rowsCells;
  final List rowsCells;
  final double fixedColWidth;
  final double cellWidth;
  final double cellHeight;
  final double cellMargin;
  final double cellSpacing;
  final List<String>? memberUsernames;

  const CustomDataTable({
    super.key,
    required this.fixedCornerCell,
    // required this.fixedColCells,
    required this.fixedRowCells,
    required this.rowsCells,
    this.fixedColWidth = 160.0,
    this.cellHeight = 110.0,
    this.cellWidth = 110.0,
    this.cellMargin = 0.0,
    this.cellSpacing = 0.0,
    required this.memberUsernames,
  });

  @override
  State<StatefulWidget> createState() => CustomDataTableState();
}

class CustomDataTableState<T> extends State<CustomDataTable<T>> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();

  UserData userData = UserData();

  Widget _buildChild(double width, T data) => SizedBox(
        width: width,
        child: Text(
          '$data',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _buildFixedCol() {
    List<SoccerMatch> scoreboardMatchesList = context.watch<ScoreboardProvider>().scoreboardMatchesList;
    ScoreboardProvider scoreboardProvider = context.watch<ScoreboardProvider>();
    scoreboardProvider.sortMatchesByDate(scoreboardProvider.scoreboardMatchesList);

    return Column(
      children: scoreboardMatchesList.map((match) {
        final homeName = match.home.name;
        final awayName = match.away.name;
        final matchId = match.fixture.id;
        final formattedDate = match.fixture.formattedDate;
        final homeScore = match.goal.home != null ? match.goal.home.toString() : '?';
        final awayScore = match.goal.away != null ? match.goal.away.toString() : '?';

        return Container(
          width: widget.fixedColWidth,
          height: widget.cellHeight,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
              border: Border(
            right: BorderSide(color: Colors.white),
            bottom: BorderSide(color: Colors.white),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                matchId.toString(),
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: widget.cellWidth,
                    child: Text(
                      homeName,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    homeScore,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: widget.cellWidth,
                    child: Text(
                      awayName,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    awayScore,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFixedRow() {
    if (widget.fixedRowCells.isNotEmpty) {
      return DataTable(
        border: TableBorder(
          verticalInside: BorderSide(color: Colors.white),
          bottom: BorderSide(color: Colors.white),
        ),
        horizontalMargin: widget.cellMargin,
        columnSpacing: widget.cellSpacing,
        headingRowHeight: widget.cellHeight,
        dataRowHeight: widget.cellHeight,
        columns: widget.fixedRowCells
            .map(
              (memberInfo) => DataColumn(
                label: _buildChild(widget.cellWidth, memberInfo['memberUsername'] as T),
              ),
            )
            .toList(),
        rows: const [],
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildColumns() {
    final scoreboardMatchesList = Provider.of<ScoreboardProvider>(context, listen: false).scoreboardMatchesList;
    final memberCount = widget.fixedRowCells.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var match in scoreboardMatchesList)
          Row(
            children: [
              for (var i = 0; i < memberCount; i++)
                Container(
                  width: widget.cellWidth,
                  height: widget.cellHeight,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.white),
                      bottom: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: _getPrediction(match.fixture.id, widget.fixedRowCells[i]['memberUid']),
                ),
            ],
          ),
      ],
    );
  }

  Widget _getPrediction(int matchId, String? memberUid) {
    var prediction = 'empty';
    var memberPredict = widget.rowsCells.firstWhere(
      (prediction) => prediction['memberUid'] == memberUid && prediction['matchId'] == matchId,
      orElse: () => null,
    );

    if (memberPredict != null) {
      prediction = memberPredict['prediction'];
    }

    return Text(
      '$matchId $prediction',
      style: const TextStyle(fontSize: 14),
    );
  }

  // Widget _buildColumns() {
  //   return Column(
  //     children: widget.rowsCells.map((rowCell) {
  //       final memberPredictions = rowCell['prediction'];

  //       return Container(
  //         width: widget.cellWidth,
  //         height: widget.cellHeight,
  //         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  //         decoration: BoxDecoration(
  //           border: Border(
  //             right: BorderSide(color: Colors.white),
  //             bottom: BorderSide(color: Colors.white),
  //           ),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: memberPredictions.map<Widget>((predictionEntry) {
  //             final matchId = predictionEntry['matchId'] ?? '';
  //             final prediction = predictionEntry['prediction'] ?? '';
  //             return Text(
  //               '$prediction',
  //               style: const TextStyle(fontSize: 14),
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildCornerCell() => DataTable(
        border: TableBorder(right: BorderSide(color: Colors.white), bottom: BorderSide(color: Colors.white)),
        // border: _buildBorder(bottom: true, right: true),
        horizontalMargin: widget.cellMargin,
        columnSpacing: widget.cellSpacing,
        headingRowHeight: widget.cellHeight,
        dataRowHeight: widget.cellHeight,
        columns: [
          DataColumn(
            label: _buildChild(
              widget.fixedColWidth,
              widget.fixedCornerCell,
            ),
          )
        ],
        rows: const [],
      );

  @override
  void initState() {
    super.initState();
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
    _subTableYController.addListener(() {
      _columnController.jumpTo(_subTableYController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.fixedColWidth + (widget.cellWidth * widget.memberUsernames!.length),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildCornerCell(),
              Flexible(
                child: SingleChildScrollView(
                  controller: _rowController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: _buildFixedRow(),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                SingleChildScrollView(
                  controller: _columnController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: _buildFixedCol(),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: _subTableXController,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: _subTableYController,
                      scrollDirection: Axis.vertical,
                      child: _buildColumns(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
