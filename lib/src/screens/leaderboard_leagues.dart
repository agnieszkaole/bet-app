import 'package:bet_app/src/constants/league_names.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardLeagues extends StatefulWidget {
  const LeaderboardLeagues({super.key});

  @override
  State<LeaderboardLeagues> createState() => _LeaderboardLeaguesState();
}

class _LeaderboardLeaguesState extends State<LeaderboardLeagues> {
  Map<String, dynamic>? selectedLeague;
  String? groupName;

  @override
  void initState() {
    super.initState();
    selectedLeague = leagueNames[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InputDecorator(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 31, 77, 10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.greenAccent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
              ),
            ),
            child: Stack(children: [
              Positioned(
                right: 0,
                top: 10,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 35,
                  color: Color.fromARGB(255, 158, 158, 158),
                ),
              ),
              SizedBox(
                height: 20,
                child: DropdownButton<Map<String, dynamic>>(
                  isExpanded: true,
                  hint: Text(
                    'Select a group',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  underline: Container(
                    height: 0,
                  ),

                  value: selectedLeague,
                  // itemHeight: kMinInteractiveDimension,
                  items: leagueNames.map((league) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: league,
                      child: Center(
                        child: Text(
                          league['name'],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLeague = value!;
                    });
                  },
                ),
              ),
            ]),
          ),
          Container(
            height: 600,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  './assets/images/cup-2015198_1280.png',
                  width: 250,
                ),
                SizedBox(height: 20),
                Text(
                  'Select a league to see leaderboard',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
        ],
      ),
    );

    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Image.asset(
    //         './assets/images/cup-2015198_1280.png',
    //         width: 250,
    //       ),
    //       SizedBox(height: 20),
    //       Text(
    //         'Select a group to see leaderboard',
    //         style: TextStyle(fontSize: 20),
    //       ),
    //     ],
    //   ),
    // );
  }
}
