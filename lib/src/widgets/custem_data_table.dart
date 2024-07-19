import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/services/scoreboard.dart';
import 'package:bet_app/src/services/user_data.dart';
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
    await Future.delayed(const Duration(milliseconds: 200));
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
              await userData.getMatchesResultsForUser(memberUid, selectedLeague, widget.groupId);

          if (memberPredictions != null) {
            for (var match in memberPredictions) {
              int matchId = match['matchId'];
              String prediction = "${match['homeGoal']} : ${match['awayGoal']}";
              // String groupId = match['groupId'];
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
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            // constraints: BoxConstraints(maxHeight: 400),
            padding: const EdgeInsets.all(8),
            // decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(25),
            // color: Color.fromARGB(235, 34, 34, 34),
            // border: Border.all(color: Color.fromARGB(255, 32, 168, 62), width: 1)),
            height: MediaQuery.of(context).size.height - 250,
            // height: 500,

            child: CustomDataTable(
                fixedCornerCell: '',
                rowsCells: _rowsCells,
                fixedRowCells: _fixedRowCells,
                memberUsernames: memberUsernames,
                groupId: widget.groupId),
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
  final String? groupId;

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
    required this.groupId,
  });

  @override
  State<StatefulWidget> createState() => CustomDataTableState();
}

class CustomDataTableState<T> extends State<CustomDataTable<T>> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();
  // late ScoreboardManagerProvider scoreboardManager;
  UserData userData = UserData();

  Widget _buildChild(double width, T data) => SizedBox(
        width: width,
        child: Text(
          '$data',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: const BoxDecoration(
            color: Color.fromARGB(57, 80, 80, 80),
            border: Border(
              right: BorderSide(
                color: Color.fromARGB(255, 73, 73, 73),
              ),
              bottom: BorderSide(
                color: Color.fromARGB(255, 119, 119, 119),
              ),
            ),
            // gradient: const LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            //   colors: [
            //     Color.fromARGB(50, 32, 168, 61),
            //     Color.fromARGB(50, 19, 114, 40),
            //     Color.fromARGB(50, 32, 168, 62),
            //   ],
            // )
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

              const SizedBox(height: 5),
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
                  const SizedBox(
                    width: 20,
                    child: Text(
                      'vs',
                      style: TextStyle(fontSize: 13),
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
                    const Text('Extratime'),
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
        decoration: const BoxDecoration(
            color: Color.fromARGB(200, 41, 41, 41),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.greenDark,
                AppColors.green,
              ],
            )),
        child: DataTable(
          border: TableBorder(
            borderRadius: BorderRadius.circular(25),
            verticalInside: const BorderSide(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
            bottom: const BorderSide(
              color: Color.fromARGB(255, 85, 85, 85),
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
      return const SizedBox();
    }
  }

  Widget _buildColumns() {
    final scoreboardMatchesList = Provider.of<ScoreboardProvider>(context, listen: false).scoreboardMatchesList;
    final memberCount = widget.fixedRowCells.length;
    // final userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';
    // final totalScores = _calculateTotalScores(scoreboardMatchesList, memberCount);

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
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(25),
                    border: Border(
                      right: BorderSide(
                        color: Color.fromARGB(255, 73, 73, 73),
                      ),
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 119, 119, 119),
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
    Color backgroundColorScore = const Color.fromARGB(255, 77, 77, 77);
    int score = 0;

    var memberPredict = widget.rowsCells.firstWhere(
      (prediction) => prediction['memberUid'] == memberUid && prediction['matchId'] == matchId,
      orElse: () => null,
    );

    if (memberPredict != null) {
      prediction = memberPredict['prediction'];
    }
    print(prediction);

    Future<void> sumScores() async {
      Scoreboard scoreboard = Scoreboard();
      if (prediction == '---' && match.goal.home == null && match.goal.away == null) {
        backgroundColor = const Color.fromARGB(113, 43, 43, 43);
      } else if (prediction == '---' &&
          match.goal.home != null &&
          match.goal.away != null &&
          match.fixture.status.long == 'Match Finished') {
        backgroundColor = const Color.fromARGB(132, 56, 56, 56);
      } else {
        if (match.goal.home != null && match.goal.home != null && match.fixture.status.long == 'Match Finished') {
          if (prediction == '${match.goal.home} : ${match.goal.away}') {
            backgroundColorScore = const Color.fromARGB(192, 22, 124, 36);
            score = 3;
            backgroundColor = const Color.fromARGB(80, 22, 124, 36);
            await scoreboard.updateScore(widget.groupId!, memberUid, matchId, score, prediction);
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
                backgroundColor = const Color.fromARGB(80, 214, 211, 0);
                backgroundColorScore = const Color.fromARGB(181, 214, 211, 0);
                score = 1;
                // print(' ${widget.groupId!}, $memberUid, $matchId, $prediction, $score, $scoreboardMatchesList');

                await scoreboard.updateScore(widget.groupId!, memberUid, matchId, score, prediction);

                // print(' ${widget.groupId!}, $memberUid, $score');
              } else {
                backgroundColor = const Color.fromARGB(80, 241, 0, 0);
                backgroundColorScore = const Color.fromARGB(120, 241, 0, 0);
                score = 0;
                await scoreboard.updateScore(widget.groupId!, memberUid, matchId, score, prediction);
              }
            }
          }
        } else {
          backgroundColor = const Color.fromARGB(148, 77, 77, 77);
        }
      }
    }

    sumScores();

    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: backgroundColor,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child:
                  (match.fixture.status.long == 'Not Started' || match.fixture.status.long == 'Time to be defined') &&
                          prediction != '---'
                      ? const Text(
                          '?  :  ?',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          prediction,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )),
          if (match.fixture.status.long == 'Match Finished' && prediction != '---')
            // if (match.fixture.status.long == 'Match Finished')
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                // color: Color.fromARGB(104, 112, 112, 112),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: backgroundColorScore,
                ),

                child: Text(
                  '+$score',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCornerCell() => Container(
        // color: Color.fromARGB(204, 37, 37, 37),
        decoration: const BoxDecoration(
            color: Color.fromARGB(200, 41, 41, 41),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.greenDark,
                AppColors.green,
              ],
            )),
        child: DataTable(
          border: TableBorder(
            borderRadius: BorderRadius.circular(25),
            right: const BorderSide(
              color: Color.fromARGB(255, 73, 73, 73),
            ),
            bottom: const BorderSide(
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
          borderRadius: BorderRadius.circular(5),
          // color: Color.fromARGB(235, 34, 34, 34),
          border: Border.all(color: const Color.fromARGB(255, 85, 85, 85), width: 0.7)),
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
