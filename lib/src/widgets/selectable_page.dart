import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import 'package:bet_app/src/widgets/scrollable_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectablePage extends StatefulWidget {
  @override
  _SelectablePageState createState() => _SelectablePageState();
}

class _SelectablePageState extends State<SelectablePage> {
  late List<SoccerMatch> scoreboardMatchesList;

  @override
  void initState() {
    super.initState();
    scoreboardMatchesList = context.read<ScoreboardProvider>().scoreboardMatchesList;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: scoreboardMatchesList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ScrollableWidget(
                      child: buildDataTable(),
                    ),
                  ),
                ],
              ),
      );

  Widget buildDataTable() {
    final users = ['', 'user 1', 'user 2', 'user 3', 'user 4'];
    late List<SoccerMatch> scoreboardMatchesList = context.watch<ScoreboardProvider>().scoreboardMatchesList;
    NextMatchesProvider.sortMatchesByDate(scoreboardMatchesList);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowMaxHeight: 80,
        columns: getColumns(users),
        rows: getRows(scoreboardMatchesList),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> users) => users
      .map((String users) => DataColumn(
            label: Text(users),
          ))
      .toList();

  List<DataRow> getRows(List<SoccerMatch> match) => match
      .map((SoccerMatch scoreboardMatch) => DataRow(
            cells: [
              DataCell(
                Container(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              ),
              DataCell(Text('dfgdfgdf')),
              DataCell(Text('asdddfg')),
              DataCell(Text('bnmbnmbn')),
              DataCell(Text('tyutyuytu'))
            ],
          ))
      .toList();
}
// Widget _generateFirstColumnRow(BuildContext context, int index) {
//   late List<SoccerMatch> scoreboardMatchesList = context.watch<ScoreboardProvider>().scoreboardMatchesList;
//   if (scoreboardMatchesList.isEmpty) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 46, 46, 46),
//       ),
//       height: 60,
//       padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//       alignment: Alignment.center,
//       child: Text(
//         'No match found',
//         style: const TextStyle(fontSize: 16),
//       ),
//     );
//   }
//   NextMatchesProvider.sortMatchesByDate(scoreboardMatchesList);
//   return SingleChildScrollView(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: scoreboardMatchesList.map((scoreboardMatch) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Color.fromARGB(255, 46, 46, 46),
//             border: Border.all(width: 0.5),
//           ),
//           height: 90,
//           padding: const EdgeInsets.only(left: 8, right: 12, top: 10, bottom: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 scoreboardMatch.fixture.formattedDate,
//                 style: const TextStyle(fontSize: 14),
//               ),
//               SizedBox(height: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${scoreboardMatch.home.name} ',
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                   Text(
//                     '${scoreboardMatch.goal.home ?? '?'}',
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${scoreboardMatch.away.name} ',
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                   Text(
//                     '${scoreboardMatch.goal.away ?? '?'}',
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     ),
//   );
// }

// Widget _getBodyWidget() {
//   late List<SoccerMatch> scoreboardMatchesList = context.watch<ScoreboardProvider>().scoreboardMatchesList;
//   // print(scoreboardMatchesList.length);
//   NextMatchesProvider.sortMatchesByDate(scoreboardMatchesList);
//   return Container(
//     height: MediaQuery.of(context).size.height,
//     child: HorizontalDataTable(
//       leftHandSideColumnWidth: 180,
//       rightHandSideColumnWidth: 600,
//       isFixedHeader: true,
//       headerWidgets: _getTitleWidget(),
//       leftSideItemBuilder: _generateFirstColumnRow,
//       rightSideItemBuilder: _generateRightHandSideColumnRow,
//       itemCount: scoreboardMatchesList.length,
//       rowSeparatorWidget: const Divider(
//         color: Colors.black54,
//         height: 0.5,
//         thickness: 1,
//       ),
//       leftHandSideColBackgroundColor: Color.fromARGB(255, 29, 29, 29),
//       rightHandSideColBackgroundColor: Color.fromARGB(255, 54, 54, 54),
//     ),
//   );
// }

// List<Widget> _getTitleWidget() {
//   List<Widget> titleWidgets = [];
//   titleWidgets.add(_getTitleItemWidget('', 350, Colors.black45));
//   for (String user in users) {
//     titleWidgets.add(
//       _getTitleItemWidget(user, 80, Color.fromARGB(255, 25, 124, 66)),
//     );
//   }

//   return titleWidgets;
// }

// Widget _getTitleItemWidget(String label, double width, Color color) {
//   return Container(
//     decoration: BoxDecoration(color: color, border: Border.all(width: 0.5)),
//     child: Center(
//       child: Text(
//         label,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
//       ),
//     ),
//     width: width,
//     height: 56,
//     padding: EdgeInsets.all(5),
//     // alignment: Alignment.centerLeft,
//   );
// }

// Widget _generateFirstColumnRow(BuildContext context, int index) {
//   late List<SoccerMatch> scoreboardMatchesList = context.watch<ScoreboardProvider>().scoreboardMatchesList;
//   if (scoreboardMatchesList.isEmpty) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 46, 46, 46),
//       ),
//       height: 60,
//       padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//       alignment: Alignment.center,
//       child: Text(
//         'No match found',
//         style: const TextStyle(fontSize: 16),
//       ),
//     );
//   }
//   NextMatchesProvider.sortMatchesByDate(scoreboardMatchesList);
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: scoreboardMatchesList.map((scoreboardMatch) {
//       return Container(
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 46, 46, 46),
//           border: Border.all(width: 0.5),
//         ),
//         height: 90,
//         padding: const EdgeInsets.only(left: 8, right: 12, top: 10, bottom: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               scoreboardMatch.fixture.formattedDate,
//               style: const TextStyle(fontSize: 14),
//             ),
//             SizedBox(height: 5),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${scoreboardMatch.home.name} ',
//                   style: const TextStyle(fontSize: 13),
//                 ),
//                 Text(
//                   '${scoreboardMatch.goal.home ?? '?'}',
//                   style: const TextStyle(fontSize: 13),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${scoreboardMatch.away.name} ',
//                   style: const TextStyle(fontSize: 13),
//                 ),
//                 Text(
//                   '${scoreboardMatch.goal.away ?? '?'}',
//                   style: const TextStyle(fontSize: 13),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     }).toList(),
//   );
// }

// Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
//   return Row(
//     children: <Widget>[
//       Container(
//         child: Center(
//           child: Text(
//             'result',
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//         width: 80,
//         height: 90,
//         alignment: Alignment.centerLeft,
//       ),
//     ],
//   );
// }
