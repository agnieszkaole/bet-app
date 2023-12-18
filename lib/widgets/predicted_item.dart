import 'package:bet_app/provider/predicted_match_provider.dart';
import 'package:bet_app/widgets/next_match_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictedItem extends StatefulWidget {
  PredictedItem({super.key, required this.predictedMatch});
  final Map<String, dynamic> predictedMatch;
  bool isNewMatch = true;

  @override
  State<PredictedItem> createState() => _PredictedItemState();
}

class _PredictedItemState extends State<PredictedItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.predictedMatch['matchTime'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.predictedMatch['teamHomeName'].toString(),
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
                    imageUrl: widget.predictedMatch['teamHomeLogo'].toString(),
                    fadeInDuration: const Duration(milliseconds: 50),
                    // placeholder: (context, url) =>
                    //     const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 36.0,
                    height: 36.0,
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
                    imageUrl: widget.predictedMatch['teamAwayLogo'].toString(),
                    // placeholder: (context, url) =>
                    //     const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 36.0,
                    // height: 36.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.predictedMatch['teamAwayName'].toString(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  child: (DateTime.now().hour > 17)
                      ? null
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 40, 122, 43),
                            ),
                            foregroundColor:
                                const Color.fromARGB(255, 176, 206, 177),
                          ),
                          onPressed: () {},
                          child: const Text('Edytuj'),

                          // onPressed: () {
                          //   context
                          //       .read<PredictedMatchProvider>()
                          //       .removeMatch(predictedMatch);
                          //   Navigator.of(context).pop();
                          // },
                          // style: ElevatedButton.styleFrom(
                          //     elevation: 3.0,
                          //     side: const BorderSide(
                          //         color: Color.fromARGB(255, 40, 122, 43)),
                          //     foregroundColor: Color.fromARGB(255, 110, 197, 113)),
                          // child: const Text('Edytuj'),
                        ),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                          width: 1,
                          color: Colors.red,
                        ),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 129, 120),
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Usuń zakład',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              content: const Text(
                                'Czy napewno chcesz usunąć ten zakład?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Nie',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 40, 122, 43),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    context
                                        .read<PredictedMatchProvider>()
                                        .removeMatch(widget.predictedMatch);
                                    Navigator.of(context).pop();
                                    // final newValue = await Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //   builder: (context) => NextMatchItem(
                                    //     isNewMatch: widget.isNewMatch,
                                    //   ),
                                    // ));
                                    // setState(() {
                                    //   widget.isNewMatch = newValue;
                                    // });
                                  },

                                  // onPressed: () {

                                  //   context
                                  //       .read<PredictedMatchProvider>()
                                  //       .removeMatch(predictedMatch);

                                  //   Navigator.of(context).pop();
                                  // },
                                  child: const Text(
                                    'Tak',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Usuń'),
                    ))
              ],
            )

            // const Divider(
            //   color: Color.fromARGB(255, 43, 43, 43),
            //   thickness: 2,
            // )
          ],
        ),
      ),
    );
  }
}
