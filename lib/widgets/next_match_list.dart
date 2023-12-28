import 'package:bet_app/models/soccermodel.dart';
// import 'package:bet_app/provider/predicted_match_provider.dart';
// import 'package:bet_app/widgets/data_picker.dart';
import 'package:bet_app/widgets/next_match_item.dart';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class NextMatchList extends StatefulWidget {
  const NextMatchList({super.key, required this.matches});
  final List<SoccerMatch> matches;

  @override
  State<NextMatchList> createState() => _NextMatchListState();
}

class _NextMatchListState extends State<NextMatchList> {
  final isMatchesExist = true;
  bool? isSelected;
  @override
  Widget build(BuildContext context) {
    return (!isMatchesExist)
        ? const Center(
            child: Text(
              'Nie znaleziono żadnych meczów.\nZmień kryteria wyszukiwania',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )
        : Column(
            children: [
              // const Text(
              //   'Zdecyduj, który mecz chcesz obstawić',
              //   style: TextStyle(fontSize: 18),
              // ),
              // SwitchListTile(
              //   value: false,
              //   onChanged: (bool newValue) {
              //     setState(() {
              //       isSelected = newValue;
              //     });
              //   },
              //   title: Text('Wybierz datę z kalendarza'),
              //   contentPadding: const EdgeInsets.only(left: 34, right: 22),
              // ),

              // const DataPicker(),
              const Text(
                'Wybrana liga - nazwa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    itemCount: widget.matches.length,
                    itemBuilder: (context, index) {
                      return NextMatchItem(
                        match: widget.matches[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
