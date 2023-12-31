import 'package:bet_app/src/widgets/main_drawer.dart';
import 'package:bet_app/src/widgets/predicted_list.dart';
import "package:flutter/material.dart";

class PredictedScreen extends StatefulWidget {
  const PredictedScreen({super.key});

  @override
  State<PredictedScreen> createState() => _PredictedScreenState();
}

class _PredictedScreenState extends State<PredictedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     'Bet',
        //     style: TextStyle(
        //       fontSize: 25,
        //     ),
        //   ),
        // ),
        drawer: const MainDrawer(),
        body: const PredictedList());
  }
}

    // body: ListView.builder(
    //   itemCount: items.length,
    //   itemBuilder: (context, index) {
    //     final item = items[index];
    //     return Dismissible(
    //       key: ValueKey(items[index]),
    //       onDismissed: (direction) {
    //         setState(() {
    //           items.remove(item);
    //         });

    //         ScaffoldMessenger.of(context)
    //             .showSnackBar(SnackBar(content: Text('$item dismissed')));
    //       },
    //       child: ListTile(
    //         title: Text(item),
    //       ),
    //     );
    //   },
    // ),