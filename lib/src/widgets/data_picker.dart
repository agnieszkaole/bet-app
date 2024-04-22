import 'package:bet_app/src/widgets/next_match_scheduled_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

// var _selectedDate = DateTime.now();
typedef DateSelectedCallback = void Function(DateTime selectedDate);

class DataPicker extends StatefulWidget {
  const DataPicker({
    super.key,
    this.onDateSelected,
    this.leagueNumber,
    this.leagueName,
  });
  final Function(DateTime)? onDateSelected;
  final String? leagueNumber;
  final String? leagueName;
  @override
  DataPickerState createState() => DataPickerState();
}

class DataPickerState extends State<DataPicker> {
  late DateTime _selectedDate = DateTime.now();

  void _handleDateChange(DateTime value) {
    if (value.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      // if (true) {
      setState(() {
        _selectedDate = value;
      });
      widget.onDateSelected!(_selectedDate);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Date"),
            content: Text("You cannot bet on previous matches. Please select today's date or later."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(_selectedDate);
    // initializeDateFormatting('pl_PL', null);

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromARGB(235, 34, 34, 34),
                border: Border.all(color: Color.fromARGB(255, 102, 102, 102), width: 0.4)),
            child: Column(
              children: [
                Text('${widget.leagueName}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 32, 168, 62),
                    )),
                SizedBox(height: 5),
                NextMatchScheduledList(leagueNumber: widget.leagueNumber),
                // Text(
                //   '↪',
                //   textAlign: TextAlign.end,
                //   style: TextStyle(
                //     fontSize: 24,
                //     color: Color.fromARGB(255, 255, 255, 255),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      // SizedBox(height: 15),
                      Text(DateFormat('d MMMM yyyy').format(_selectedDate)),
                      WeeklyDatePicker(
                        selectedDay: _selectedDate,
                        changeDay: (value) => _handleDateChange(value),
                        enableWeeknumberText: false,
                        weeknumberColor: Color.fromARGB(255, 36, 165, 41),
                        weeknumberTextColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        weekdayTextColor: const Color(0xFF8A8A8A),
                        digitsColor: Colors.white,
                        selectedDigitBackgroundColor: const Color.fromARGB(255, 40, 122, 43),
                        daysInWeek: 7,
                      ),
                    ],
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
