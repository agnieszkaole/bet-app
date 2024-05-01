import 'package:bet_app/src/screens/new_group_screen.dart';
import 'package:bet_app/src/screens/join_existing_group_screen.dart';
import 'package:bet_app/src/screens/user_groups.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'A quick look at the rules',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  '👇',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Betting rules',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(118, 51, 51, 51),
                  border: Border.all(
                    width: .5,
                    color: Color.fromARGB(224, 102, 102, 102),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        './assets/images/football-157931_1280.png',
                        width: 30,
                      ),
                      title: Container(
                        child: Text(
                          'You cannot bet on previous matches.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        './assets/images/football-157931_1280.png',
                        width: 30,
                      ),
                      title: Container(
                        child: Text(
                          'The time for betting ends at 0 minutes before the match starts.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        './assets/images/football-157931_1280.png',
                        width: 30,
                      ),
                      title: Container(
                        child: Text(
                          'The prediction can only be edited until the match starts.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        './assets/images/football-157931_1280.png',
                        width: 30,
                      ),
                      title: Container(
                        child: Text(
                          'Your predictions will be visible in the Bets table only after the prediction time has expired. Until then the question mark ("?") is displayed.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Scoring rules',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(118, 51, 51, 51),
                  border: Border.all(
                    width: .5,
                    color: Color.fromARGB(224, 102, 102, 102),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Color.fromARGB(210, 39, 39, 39),
                  //     Color.fromARGB(210, 39, 39, 39),
                  //   ],
                  // ),
                  // color: Color.fromARGB(255, 39, 39, 39),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 55,
                        padding: EdgeInsets.all(5),
                        // color: Color.fromARGB(104, 112, 112, 112),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(192, 22, 124, 36),
                        ),
                        child: Text(
                          '3 pts',
                          style: TextStyle(
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 1.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: Container(
                        child: Text(
                          'Exact result',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      subtitle: Text('Correctly predicted the exact result.'),
                    ),
                    ListTile(
                      leading: Container(
                        width: 55,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(230, 175, 172, 9),
                        ),
                        child: Text(
                          '1 pt',
                          style: TextStyle(
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 1.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: Text(
                        'Trend of result',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text('Correctly predicted the trend of result (win, draw, lose).'),
                    ),
                    ListTile(
                      // leading: Image.asset(
                      //   './assets/images/football-157931_1280.png',
                      //   width: 30,
                      // ),
                      leading: Container(
                        width: 55,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(120, 241, 0, 0),
                        ),
                        child: Text(
                          '0 pt',
                          style: TextStyle(
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 1.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: Text(
                        'Wrong result',
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text('Inorrectly predicted the result.'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
