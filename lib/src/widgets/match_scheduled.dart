import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/provider/predicted_match_provider.dart';
import 'package:bet_app/src/widgets/data_picker.dart';
import 'package:bet_app/src/widgets/group_match_item.dart';
import 'package:bet_app/src/widgets/group_match_list.dart';
import 'package:bet_app/src/widgets/next_match_item.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:bet_app/src/widgets/next_match_scheduled_list.dart';
import 'package:bet_app/src/widgets/next_match_scheduled_item.dart';
import 'package:bet_app/src/widgets/predict_result.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MatchScheduled extends StatefulWidget {
  MatchScheduled({
    super.key,
    this.leagueName,
    this.leagueNumber,
    this.leagueLogo,
    this.groupId,
  });
  final String? leagueName;
  final String? leagueNumber;
  final String? leagueLogo;
  final String? groupId;

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
    // final ScrollController _scrollController = ScrollController();
    // late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
    // print(nextMatchesList);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // SizedBox(height: 10),
          DataPicker(
              onDateSelected: (selectedDate) {
                _selectedDate = selectedDate;
                setState(() {
                  formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
                });
              },
              leagueNumber: widget.leagueNumber,
              leagueName: widget.leagueName),

          Expanded(
            child: GroupMatchList(
              selectedDate: formattedDate,
              leagueNumber: widget.leagueNumber,
              groupId: widget.groupId,
            ),
          ),

          SizedBox(height: 10)
        ],
      ),
    );
  }
}
