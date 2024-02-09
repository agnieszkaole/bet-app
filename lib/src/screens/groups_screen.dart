// import 'package:bet_app/src/widgets/main_drawer.dart';
import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/screens/new_group_screen.dart';
import 'package:bet_app/src/screens/join_existing_group_screen.dart';
import 'package:bet_app/src/screens/user_groups.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
          // width: MediaQuery.of(context).size.width - 20,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 110,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const NewGroupScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(10)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 0, 64, 128)),
                            shape: const MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ))),
                            side: const MaterialStatePropertyAll(
                              BorderSide(
                                  color: Color.fromARGB(255, 30, 77, 60),
                                  width: 1),
                            )),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Create a new group",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.format_list_bulleted_add,
                              color: Colors.white,
                              size: 35,
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(width: 20),

                  // Icon(
                  //   Icons.group_add_rounded,
                  //   color: Colors.white,
                  //   size: 35,
                  // ),
                  Container(
                    width: 160,
                    height: 110,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GroupListScreen(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 0, 90, 58)),
                          shape: const MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ))),
                          side: const MaterialStatePropertyAll(
                            BorderSide(
                                color: Color.fromARGB(255, 30, 77, 60),
                                width: 1),
                          )),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Join an existing group",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.group_add_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              UserGroups()
            ],
          ),
        ),
      ),
    );
  }
}
