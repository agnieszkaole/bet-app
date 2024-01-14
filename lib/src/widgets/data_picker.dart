import 'package:bet_app/src/models/soccermodel.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

var _selectedDate = DateTime.now();

class DataPicker extends StatefulWidget {
  const DataPicker({super.key});

  @override
  DataPickerState createState() => DataPickerState();
}

class DataPickerState extends State<DataPicker> {
  // DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(_selectedDate);
    initializeDateFormatting('pl_PL', null);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Text(DateFormat('d MMMM yyyy', 'pl_PL').format(_selectedDate)),
          WeeklyDatePicker(
            selectedDay: _selectedDate,
            changeDay: (value) => setState(
              () {
                _selectedDate = value;
              },
            ),
            enableWeeknumberText: false,
            weeknumberColor: const Color.fromARGB(255, 40, 122, 43),
            weeknumberTextColor: Colors.white,
            backgroundColor: const Color(0xFF1A1A1A),
            weekdayTextColor: const Color(0xFF8A8A8A),
            digitsColor: Colors.white,
            selectedBackgroundColor: const Color.fromARGB(255, 40, 122, 43),
            weekdays: const ["Pn", "Wt", "Śr", "Cz", "Pt", "Sb", "Nd"],
            daysInWeek: 7,
          ),
        ],
      ),
    );
  }
}
