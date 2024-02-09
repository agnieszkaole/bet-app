import 'package:bet_app/src/screens/user_profile.dart';
import 'package:bet_app/src/widgets/group_details.dart';
import 'package:bet_app/src/widgets/predict_result.dart';
import 'package:bet_app/src/widgets/predicted_result_edith.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class GroupTable extends StatefulWidget {
  const GroupTable({super.key});

  @override
  State<GroupTable> createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;
  List users = ['Maciej', 'Staś', 'Grzesiek', 'Krzysiek', 'Piotrek'];
  List<String> matches = [
    'Polska - Niemcy',
    'Hiszpania - Anglia',
    'Grecja - Dania',
    'Portugalia - Czechy',
    'Polska - Niemcy',
    'Hiszpania - Anglia',
    'Grecja - Dania',
    'Portugalia - Czechy',
    'Polska - Niemcy',
    'Hiszpania - Anglia',
    'Grecja - Dania',
    'Portugalia - Czechy',
    'Polska - Niemcy',
    'Hiszpania - Anglia',
    'Grecja - Dania',
    'Portugalia - Czechy',
  ];

  @override
  void initState() {
    super.initState();
  }

  void initData(int size) {
    for (int i = 0; i < size; i++) {
      users.add(users[i]);
    }
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('dfgdfgd'),
          _getBodyWidget(),
        ],
      ),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 160,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: matches.length,
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
        _getTitleItemWidget(user, 80, const Color.fromARGB(255, 35, 88, 37)),
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
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      // alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(
        //   width: 0.5,
        //   color: Colors.white,
        // ),
        color: Color.fromARGB(255, 46, 46, 46),
      ),
      // width: 250,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(matches[index], style: const TextStyle(fontSize: 16)),
        ],
      ),
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
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Center(
            child: Text(
              'wynik',
              style: TextStyle(fontSize: 18),
            ),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Center(
            child: Text(
              'wynik',
              style: TextStyle(fontSize: 18),
            ),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Center(
            child: Text(
              'wynik',
              style: TextStyle(fontSize: 18),
            ),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Center(
            child: Text(
              'wynik',
              style: TextStyle(fontSize: 18),
            ),
          ),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

// class StudentInfo {
//   String name;
//   bool status;
//   String roll_no;
//   String start_time;
//   String end_time;

//   StudentInfo(
//       this.name, this.status, this.roll_no, this.start_time, this.end_time);
// }

// Student user = Student();

// class Student {
//   List<StudentInfo> _userInfo = [];

//   void initData(int size) {
//     for (int i = 0; i < size; i++) {
//       _userInfo.add(StudentInfo(
//           "Student_$i", i % 3 == 0, 'St_No $i', '10:00 AM', '12:30 PM'));
//     }
//   }

//   List<StudentInfo> get userInfo => _userInfo;

//   set userInfo(List<StudentInfo> value) {
//     _userInfo = value;
//   }

//   ///
//   /// Single sort, sort Name's id
//   void sortName(bool isAscending) {
//     _userInfo.sort((a, b) {
//       int? aId = int.tryParse(a.name.replaceFirst('Student_', ''));
//       int? bId = int.tryParse(b.name.replaceFirst('Student_', ''));
//       return (aId! - bId!) * (isAscending ? 1 : -1);
//     });
//   }
// }


  // List users = ['Maciej', 'Staś', 'Grzesiek', 'Krzysiek', 'Piotrek'];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           Container(
  //               decoration: BoxDecoration(
  //                   color: const Color.fromARGB(221, 129, 129, 129)),
  //               child: _getBodyWidget()),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _getBodyWidget() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     child: HorizontalDataTable(
  //       leftHandSideColumnWidth: 120,
  //       rightHandSideColumnWidth: 600,
  //       isFixedHeader: true,
  //       leftHandSideColBackgroundColor: Color.fromARGB(255, 27, 27, 27),
  //       rightHandSideColBackgroundColor: Color.fromARGB(255, 27, 27, 27),
  //       headerWidgets: _getTitleWidget(),
  //       leftSideItemBuilder: _generateFirstColumnRow,
  //       rightSideItemBuilder: _generateRightHandSideColumnRow,
  //       itemCount: 4,
  //       rowSeparatorWidget: const Divider(
  //         color: Color.fromARGB(255, 255, 255, 255),
  //         height: 1.0,
  //         thickness: 0.0,
  //       ),
  //     ),
  //   );
  // }

  // List<Widget> _getTitleWidget() {
  //   List<Widget> titleWidgets = [];
  //   titleWidgets.add(_getTitleItemWidget("", 350));
  //   for (String user in users) {
  //     titleWidgets.add(
  //       _getTitleItemWidget(user, 70),
  //     );
  //   }

  //   return titleWidgets;
  // }

  // Widget _getTitleItemWidget(String label, double width) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         width: 0.5,
  //         color: Colors.white,
  //       ),
  //       color: Color.fromARGB(255, 1, 100, 6),
  //     ),
  //     width: width,
  //     height: 56,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.center,
  //     child: Text(
  //       label,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  // Widget _generateFirstColumnRow(BuildContext context, int index) {
  //   List<String> matches = [
  //     'Polska - Niemcy',
  //     'Hiszpania - Anglia',
  //     'Grecja - Dania',
  //     'Portugalia - Czechy'
  //   ];

  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         width: 0.5,
  //         color: Colors.white,
  //       ),
  //       color: Color.fromARGB(255, 46, 46, 46),
  //     ),
  //     width: 200,
  //     height: 52,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.center,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(matches[index], style: const TextStyle(fontSize: 16)),
  //       ],
  //     ),
  //   );
  // }

  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             width: 0.5,
  //             color: Colors.white,
  //           ),
  //         ),
  //         width: 70,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //         child: Text('1 : 1',
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             width: 0.5,
  //             color: Colors.white,
  //           ),
  //         ),
  //         width: 70,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //         child: Text('2 : 2', style: TextStyle(fontSize: 16)),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             width: 0.5,
  //             color: Colors.white,
  //           ),
  //         ),
  //         width: 70,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //         child: Text('3 : 3', style: TextStyle(fontSize: 16)),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             width: 0.5,
  //             color: Colors.white,
  //           ),
  //         ),
  //         width: 70,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //         child: Text('4 : 4', style: TextStyle(fontSize: 16)),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             width: 0.5,
  //             color: Colors.white,
  //           ),
  //         ),
  //         width: 70,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.center,
  //         child: Text('5 : 5', style: TextStyle(fontSize: 16)),
  //       ),
  //     ],
  //   );
  // }
// }
