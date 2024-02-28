import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/group_match_item.dart';
import 'package:bet_app/src/widgets/group_match_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MatchScheduled extends StatefulWidget {
  MatchScheduled({
    super.key,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
  });
  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;
  @override
  State<MatchScheduled> createState() => _MatchScheduledState();
}

class _MatchScheduledState extends State<MatchScheduled> {
  DateTime _selectedDate = DateTime.now();
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(widget.leagueName!, style: TextStyle(fontSize: 20)),
          DataPicker(
            onDateSelected: (selectedDate) {
              _selectedDate = selectedDate;
              setState(() {
                formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
              });

              // print(selectedDate);
              print(formattedDate);
            },
          ),
          GroupMatchList(
            selectedDate: formattedDate,
            leagueNumber: widget.leagueNumber,
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
