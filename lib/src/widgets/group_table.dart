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
      body: Container(
          decoration:
              BoxDecoration(color: const Color.fromARGB(221, 129, 129, 129)),
          child: _getBodyWidget()),
    );
  }

  Widget _getBodyWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 400,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: 100,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Name', 100),
      _getTitleItemWidget('Status', 100),
      _getTitleItemWidget('Number', 100),
      _getTitleItemWidget('Date', 100),
      _getTitleItemWidget('Name', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    String username = index < users.length ? users[index] : '';

    return Container(
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Text(username,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.notifications_active,
                  color: index % 3 == 0 ? Colors.red : Colors.green),
              Text(index % 3 == 0 ? 'Disabled' : 'Active',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black))
            ],
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('+001 9999 9999',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('2019-01-01',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('N/A',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
