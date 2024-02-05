import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class GroupTable extends StatefulWidget {
  const GroupTable({super.key});

  @override
  State<GroupTable> createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
  @override
  List users = ['Maciej', 'Grzesiek', 'Krzysiek', 'Piotrek'];

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(221, 129, 129, 129)),
                child: _getBodyWidget()),
          ],
        ),
      ),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 400,
        leftHandSideColBackgroundColor: Color.fromARGB(255, 27, 27, 27),
        rightHandSideColBackgroundColor: Color.fromARGB(255, 27, 27, 27),
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: 4,
        rowSeparatorWidget: const Divider(
          color: Color.fromARGB(255, 255, 255, 255),
          height: 2.0,
          thickness: 0.0,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> titleWidgets = [];
    titleWidgets.add(_getTitleItemWidget("", 300));
    for (String user in users) {
      titleWidgets.add(
        _getTitleItemWidget(user, 100),
      );
    }

    return titleWidgets;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.white,
        ),
        color: Color.fromARGB(255, 1, 100, 6),
      ),
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Text(label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    List<String> matches = [
      'Polska - Niemcy',
      'Hiszpania - Anglia',
      'Grecja - Dania',
      'Portugalia - Czechy'
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.white,
        ),
        color: Color.fromARGB(255, 46, 46, 46),
      ),
      width: 300,
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
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text('1 : 1',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text('2 : 2', style: TextStyle(fontSize: 16)),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text('3 : 3', style: TextStyle(fontSize: 16)),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: Text('4 : 4', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
