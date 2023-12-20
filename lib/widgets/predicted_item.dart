import 'package:bet_app/models/soccermodel.dart';
import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:bet_app/widgets/predicted_item_edith.dart';
import 'package:bet_app/widgets/next_match_item.dart';
import 'package:bet_app/widgets/predicted_result_edith.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictedItem extends StatefulWidget {
  PredictedItem({
    super.key,
    required this.predictedMatch,
  });
  Map<String, dynamic> predictedMatch;

  @override
  State<PredictedItem> createState() => _PredictedItemState();
}

class _PredictedItemState extends State<PredictedItem> {
  bool isNewMatch = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          border:
              Border.all(width: 1, color: Color.fromARGB(162, 145, 145, 145)),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.predictedMatch['leagueName'],
              // style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.predictedMatch['matchTime'],
              // style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.predictedMatch['teamHomeName'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.predictedMatch['teamHomeLogo'],
                    fadeInDuration: const Duration(milliseconds: 50),
                    // placeholder: (context, url) =>
                    //     const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 30.0,
                    // height: 30.0,
                  ),

                  //  Image.network(
                  //   homeLogo,
                  //   width: 36.0,
                  // height: 36.0,
                  // ),
                ),
                Expanded(
                  child: Text(
                    "${widget.predictedMatch['teamHomeGoal']} - ${widget.predictedMatch['teamAwayGoal']}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.predictedMatch['teamAwayLogo'],
                    // placeholder: (context, url) =>
                    //     const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 30.0,
                    // height: 30.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.predictedMatch['teamAwayName'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 120,
              height: 35,
              child: (DateTime.now().hour > 22)
                  ? null
                  : TextButton(
                      style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 40, 122, 43),
                        ),
                        foregroundColor:
                            const Color.fromARGB(255, 176, 206, 177),
                      ),
                      // onPressed: () {},
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PredictedResultEdith(),
                        ));
                      },
                      child: const Text('Edytuj'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
