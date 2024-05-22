import 'package:bet_app/src/widgets/data_picker.dart';

import 'package:bet_app/src/widgets/group_match_list.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime? _selectedDate = DateTime.now();
  String? formattedDate;
  bool _isCalendarVisible = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    });
  }

  void _handleCalendarVisibilityChanged(bool isVisible) {
    setState(() {
      _isCalendarVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final ScrollController _scrollController = ScrollController();
    // late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
    // print(nextMatchesList);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          // SizedBox(height: 10),
          SizedBox(
            width: 280,
            child: Text(
              '${widget.leagueName}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 2, 177, 2),
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          DataPicker(
              onDateSelected: (selectedDate) {
                _selectedDate = selectedDate;
                setState(() {
                  formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                });
              },
              onCalendarVisibilityChanged: _handleCalendarVisibilityChanged,
              leagueNumber: widget.leagueNumber,
              leagueName: widget.leagueName),
          const SizedBox(height: 10),
          Expanded(
            child: GroupMatchList(
              selectedDate: formattedDate,
              leagueNumber: widget.leagueNumber,
              groupId: widget.groupId,
              isCalendarVisible: _isCalendarVisible,
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
