import 'package:flutter/material.dart';

class PredictedItem extends StatefulWidget {
  const PredictedItem({super.key});

  @override
  State<PredictedItem> createState() => _PredictedItemState();
}

class _PredictedItemState extends State<PredictedItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 43, 43, 43),
      margin: const EdgeInsets.all(10.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('15.11.2023 - 20:45'),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "team1",
                        style: TextStyle(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.sports_soccer,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "vs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.sports_soccer,
                          size: 30,
                        ),
                      ),
                      Text(
                        "team2",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
