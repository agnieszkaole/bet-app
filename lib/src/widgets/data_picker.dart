import 'package:bet_app/src/constants/app_colors.dart';
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
    this.onCalendarVisibilityChanged,
    this.leagueNumber,
    this.leagueName,
  });
  final Function(DateTime)? onDateSelected;
  final Function(bool)? onCalendarVisibilityChanged;
  final String? leagueNumber;
  final String? leagueName;
  @override
  DataPickerState createState() => DataPickerState();
}

class DataPickerState extends State<DataPicker> {
  late DateTime _selectedDate = DateTime.now();
  bool _isCalendarVisible = false;

  void _handleDateChange(DateTime value) {
    // if (value.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
    // if (true) {
    setState(() {
      _selectedDate = value;
    });
    widget.onDateSelected!(_selectedDate);
    // }
    // else {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text("Invalid Date"),
    //         content: const Text("You cannot bet on previous matches. Please select today's date or later."),
    //         actions: [
    //           TextButton(
    //             child: const Text("OK"),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    // print(_selectedDate);
    // initializeDateFormatting('pl_PL', null);

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isCalendarVisible
                        ? const Text(
                            'Show all matches',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )
                        : const Text(
                            'Show calendar',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isCalendarVisible,
                      activeColor: AppColors.green,
                      inactiveTrackColor: const Color.fromARGB(137, 78, 78, 78),
                      onChanged: (bool value) {
                        setState(() {
                          _isCalendarVisible = value;
                        });
                        if (widget.onCalendarVisibilityChanged != null) {
                          widget.onCalendarVisibilityChanged!(value);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _isCalendarVisible,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(173, 5, 71, 17),
                      // gradient: const LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: [
                      //     Color.fromARGB(150, 45, 112, 14),
                      //     Color.fromARGB(150, 22, 53, 7),
                      //   ],
                      // ),
                      border: Border.all(
                        width: .8,
                        color: const Color.fromARGB(192, 22, 124, 36),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        NextMatchScheduledList(leagueNumber: widget.leagueNumber),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Column(
                            children: [
                              Text(DateFormat('d MMMM yyyy').format(_selectedDate)),
                              WeeklyDatePicker(
                                selectedDay: _selectedDate ?? DateTime.now(),
                                changeDay: (value) => _handleDateChange(value),
                                enableWeeknumberText: false,
                                weeknumberColor: const Color.fromARGB(255, 36, 165, 41),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
