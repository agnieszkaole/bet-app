import 'package:bet_app/models/soccermodel.dart';
import 'package:bet_app/widgets/data_picker.dart';
import 'package:bet_app/widgets/next_match_item.dart';
import 'package:bet_app/widgets/predict_result.dart';

import 'package:flutter/material.dart';

class NextMatchList extends StatelessWidget {
  const NextMatchList({super.key, required this.matches});
  final List<SoccerMatch> matches;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const DataPicker(),
      const Text(
        'Wybierz ligę',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      Text(
        "",
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
              return
                  // key: ValueKey(matches[index]),
                  NextMatchItem(
                match: matches[index],
              );
            },
          ),
        ),
      ),

      // Expanded(
      //   child: SingleChildScrollView(
      //     child: ExpansionPanelList.radio(
      //       animationDuration: const Duration(seconds: 1),
      //       expandedHeaderPadding: const EdgeInsets.all(10),
      //       // dividerColor: Colors.red,
      //       elevation: 4,
      //       expansionCallback: (index, isExpanded) {
      //         setState(() {
      //           _items[index]['isExpanded'] = isExpanded;
      //         });
      //       },
      //       children: _items
      //           .map(
      //             (item) => ExpansionPanelRadio(
      //               value: item['id'],
      //               canTapOnHeader: true,
      //               headerBuilder: (_, isExpanded) => Container(
      //                   padding: const EdgeInsets.symmetric(
      //                       vertical: 15, horizontal: 30),
      //                   child: Text(
      //                     item['title'],
      //                     style: const TextStyle(fontSize: 20),
      //                   )),
      //               body: Container(
      //                 padding: const EdgeInsets.symmetric(
      //                     vertical: 15, horizontal: 30),
      //                 child: Text(item['description']),
      //               ),
      //               // isExpanded: item['isExpanded'],
      //             ),
      //           )
      //           .toList(),
      //     ),
      //   ),
      // )
    ]);
  }
}
