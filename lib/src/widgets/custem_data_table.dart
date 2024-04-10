import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/services/scoreboard.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          return Container(
            // constraints: BoxConstraints(maxHeight: double.infinity),
            // padding: EdgeInsets.all(10),

            height: MediaQuery.of(context).size.height - 250,
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
    this.fixedColWidth = 200.0,
    this.cellHeight = 100.0,
    this.cellWidth = 90.0,
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
        // final matchId = match.fixture.id;
        final formattedDate = match.fixture.formattedDate;
        final homeScore = match.goal.home != null ? match.goal.home.toString() : '?';
        final awayScore = match.goal.away != null ? match.goal.away.toString() : '?';

        return Container(
          width: widget.fixedColWidth,
          height: widget.cellHeight,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 48, 48, 48),
            border: Border(
              right: BorderSide(
                color: Color.fromARGB(255, 73, 73, 73),
              ),
              bottom: BorderSide(
                color: Color.fromARGB(255, 73, 73, 73),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Text(
                '${match.fixture.status.long} (${match.fixture.status.short})',
                style: const TextStyle(fontSize: 14),
              ),

              SizedBox(height: 5),
              // Text(
              //   matchId.toString(),
              //   style: const TextStyle(fontSize: 14),
              // ),
              // SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      homeName,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    child: Text(
                      'vs',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      awayName,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    match.score.penalty.home != null
                        ? '$homeScore (${match.score.penalty.home})'
                        : match.score.extratime.home != null
                            ? '$homeScore (${match.score.extratime.home})'
                            : homeScore,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    match.score.penalty.away != null
                        ? '$awayScore (${match.score.penalty.away})'
                        : match.score.extratime.away != null
                            ? '$awayScore (${match.score.extratime.away})'
                            : awayScore,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if ((match.score.extratime.home != null && match.score.extratime.home != 0) &&
                  (match.score.extratime.away != null && match.score.extratime.away != 0))
                Column(
                  children: [
                    Text('Extratime'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${match.score.extratime.home}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${match.score.extratime.away}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              // if (match.score.penalty.home != null && match.score.penalty.away != null)
              //   Column(
              //     children: [
              //       Text('Penaulty'),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           Text(
              //             '${match.score.penalty.home}',
              //             style: const TextStyle(fontSize: 14),
              //           ),
              //           Text(
              //             '${match.score.penalty.away}',
              //             style: const TextStyle(fontSize: 14),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFixedRow() {
    if (widget.fixedRowCells.isNotEmpty) {
      return Container(
        // color: Color.fromARGB(255, 37, 37, 37),
        color: Color.fromARGB(255, 6, 102, 18),
        child: DataTable(
          border: TableBorder(
            verticalInside: BorderSide(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
          ),
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          // headingRowHeight: widget.cellHeight,
          headingRowHeight: 50,
          dataRowHeight: widget.cellHeight,
          columns: widget.fixedRowCells
              .map(
                (memberInfo) => DataColumn(
                  label: _buildChild(widget.cellWidth, memberInfo['memberUsername'] as T),
                ),
              )
              .toList(),
          rows: const [],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildColumns() {
    final scoreboardMatchesList = Provider.of<ScoreboardProvider>(context, listen: false).scoreboardMatchesList;
    final memberCount = widget.fixedRowCells.length;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

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
                  // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Color.fromARGB(255, 73, 73, 73),
                      ),
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 73, 73, 73),
                      ),
                    ),
                  ),
                  child: _getPrediction(match.fixture.id, widget.fixedRowCells[i]['memberUid']!),
                ),
            ],
          ),
      ],
    );
  }

  Widget _getPrediction(int matchId, String memberUid) {
    final scoreboardMatchesList = Provider.of<ScoreboardProvider>(context, listen: false).scoreboardMatchesList;
    var prediction = '---';
    final match = scoreboardMatchesList.firstWhere((match) => match.fixture.id == matchId);
    Color backgroundColor = const Color.fromARGB(255, 136, 136, 136);
    int score = 0;
    final scoreboard = Scoreboard();
    bool isNewPrediction = true;

    void someFunction() {
      scoreboard.isPredictionNew(prediction, memberUid, matchId).then((isNewPrediction) {
        if (isNewPrediction) {
          Scoreboard().addScores(memberUid, score);
          isNewPrediction == !isNewPrediction;
        } else {
          print('Prediction already exists, skipping score addition');
        }
      });
    }

    var memberPredict = widget.rowsCells.firstWhere(
      (prediction) => prediction['memberUid'] == memberUid && prediction['matchId'] == matchId,
      orElse: () => null,
    );

    if (memberPredict != null) {
      prediction = memberPredict['prediction'];
    }

    if (prediction == '---' && match.goal.home == null && match.goal.away == null) {
      backgroundColor = const Color.fromARGB(255, 102, 102, 102);
    } else if (prediction == '---' &&
        match.goal.home != null &&
        match.goal.away != null &&
        match.fixture.status.long == 'Match Finished') {
      backgroundColor = Color.fromARGB(255, 56, 56, 56);
    } else {
      if (match.goal.home != null && match.goal.home != null && match.fixture.status.long == 'Match Finished') {
        if (prediction == '${match.goal.home} : ${match.goal.away}') {
          backgroundColor = Color.fromARGB(162, 22, 124, 36);
          score = 3;

          if (isNewPrediction) {
            Scoreboard().addScores(memberUid, score);
          }
        } else {
          List<String> predictedScores = prediction.split(':');
          if (predictedScores.length == 2) {
            int predictedHomeScore = int.tryParse(predictedScores[0]) ?? 0;
            int predictedAwayScore = int.tryParse(predictedScores[1]) ?? 0;
            int actualHomeScore = match.goal.home ?? 0;
            int actualAwayScore = match.goal.away ?? 0;

            if ((predictedHomeScore > predictedAwayScore && actualHomeScore > actualAwayScore) ||
                (predictedHomeScore < predictedAwayScore && actualHomeScore < actualAwayScore) ||
                (predictedHomeScore == predictedAwayScore && actualHomeScore == actualAwayScore)) {
              backgroundColor = Color.fromARGB(181, 214, 211, 0);
              score = 1;

              Scoreboard().addScores(memberUid, score);
            } else {
              backgroundColor = Color.fromARGB(133, 241, 0, 0);
              score = 0;

              Scoreboard().addScores(memberUid, score);
            }
          }
        }
      } else {
        backgroundColor = Color.fromARGB(255, 77, 77, 77);
      }
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: backgroundColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '$prediction',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (match.fixture.status.long == 'Match Finished')
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                color: Color.fromARGB(104, 112, 112, 112),
                child: Text(
                  '+${score}',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCornerCell() => Container(
        color: Color.fromARGB(255, 37, 37, 37),
        child: DataTable(
          border: TableBorder(
            right: BorderSide(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
          ),
          // border: _buildBorder(bottom: true, right: true),
          horizontalMargin: widget.cellMargin,
          columnSpacing: widget.cellSpacing,
          headingRowHeight: 50,
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
        ),
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
        border: Border.all(
          color: Color.fromARGB(255, 73, 73, 73),
        ),
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
