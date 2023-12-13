import 'package:bet_app/widgets/data_picker.dart';
import 'package:flutter/material.dart';
import 'package:bet_app/widgets/next_match_item.dart';

class NextMatchList extends StatelessWidget {
  const NextMatchList({super.key, required this.matches});
  final List matches;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DataPicker(),
        const Text(
          'Mistrzostwa Europy 2024 - kwalifikacje',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                return NextMatchItem(match: matches[index]);
              },
            ),
          ),
        )
      ],
    );
  }
}
// Widget nextMatchList(List allmatches) {}
