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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Let\'s bet with friends',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '   🤝',
                    style: TextStyle(fontSize: 26),
                  ),
                ],
              ),
              // Text(
              //   'Betting rules',
              //   style: TextStyle(fontSize: 18),
              // ),
              // UserGroups(),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: Color.fromARGB(255, 39, 39, 39),
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
                            'Create a new group and invite your friends.',
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
                                Color.fromARGB(255, 62, 155, 19),
                                Color.fromARGB(255, 31, 77, 10),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            // border: Border.all(color: Color.fromARGB(255, 2, 47, 64), width: 1),
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

              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: Color.fromARGB(255, 39, 39, 39)),
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
                              Color.fromARGB(200, 247, 191, 35),
                              Color.fromARGB(200, 167, 77, 4),
                              // Color.fromARGB(100, 0, 179, 80),
                              // Color.fromARGB(100, 0, 80, 36),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          // border: Border.all(color: Color.fromARGB(255, 2, 47, 64), width: 1),
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
              SizedBox(height: 15),
              UserGroups(),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
