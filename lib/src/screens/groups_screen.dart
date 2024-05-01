import 'package:bet_app/src/screens/new_group_screen.dart';
import 'package:bet_app/src/screens/join_existing_group_screen.dart';
import 'package:bet_app/src/screens/user_groups.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(118, 14, 71, 0),
                  border: Border.all(
                    width: .5,
                    color: Color.fromARGB(224, 102, 102, 102),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Choose your betting method ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '💡',
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(118, 51, 51, 51),
                  border: Border.all(
                    width: .5,
                    color: Color.fromARGB(224, 102, 102, 102),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),

                  // color: Color.fromARGB(100, 39, 39, 39),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Color.fromARGB(100, 62, 155, 19),
                  //     Color.fromARGB(100, 31, 77, 10),
                  //   ],
                  // ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => NewGroupScreen(),
                    ))
                        .then((value) {
                      if (value != null && value == true) {
                        setState(() {});
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          // width: 300,
                          // color: const Color.fromARGB(255, 148, 119, 13),
                          child: Text(
                            'Create a new group, select a league and invite your friends.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                          width: 105,
                          height: 90,
                          margin: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 31, 77, 10),
                                Color.fromARGB(255, 79, 194, 25),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            border: Border.all(color: Color.fromARGB(174, 187, 187, 187), width: 0.5),
                          ),
                          child: Center(
                            child: Text(
                              "Create",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 15),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              //   decoration: BoxDecoration(
              //     color: Color.fromARGB(118, 14, 71, 0),
              //     border: Border.all(
              //       width: .5,
              //       color: Color.fromARGB(224, 102, 102, 102),
              //     ),
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(25),
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(
              //         'or',
              //         style: TextStyle(fontSize: 20),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: .5,
                    color: Color.fromARGB(224, 102, 102, 102),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: Color.fromARGB(118, 51, 51, 51),
                  // color: Color.fromARGB(100, 39, 39, 39),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     Color.fromARGB(159, 51, 53, 190),
                  //     Color.fromARGB(159, 0, 137, 223),

                  //     // Color.fromARGB(100, 0, 0, 70),
                  //     // Color.fromARGB(100, 28, 181, 224),
                  //   ],
                  // ),
                ),
                // color: Color.fromARGB(255, 39, 39, 39)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => GroupListScreen(),
                    ))
                        .then((value) {
                      if (value != null && value == true) {
                        setState(() {});
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 105,
                        height: 90,
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              // Color.fromARGB(255, 0, 137, 223),
                              // Color.fromARGB(255, 54, 55, 149),
                              Color.fromARGB(255, 79, 194, 25),
                              Color.fromARGB(255, 31, 77, 10),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          border: Border.all(color: Color.fromARGB(174, 187, 187, 187), width: 0.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Join",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            // SizedBox(width: 20),
                            // Icon(
                            //   Icons.group_add_rounded,
                            //   color: Colors.white,
                            //   size: 30,
                            // ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // width: 300,
                          child: Text(
                            'Join one of the existing public or private groups.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(118, 14, 71, 0),
                  border: Border.all(
                    width: .5,
                    color: Color.fromARGB(224, 102, 102, 102),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('You can use both of them ', style: TextStyle(fontSize: 20)),
                    Text(' 👍 ', style: TextStyle(fontSize: 26)),
                  ],
                ),
              ),
              // SizedBox(height: 30),
              Divider(
                height: 80,
                thickness: 1.5,
                color: Color.fromARGB(255, 20, 99, 0),
              ),
              UserGroups(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
