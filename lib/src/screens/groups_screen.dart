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
          // width: MediaQuery.of(context).size.width - 20,
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                // Text(
                //   'Create a new group.',
                //   style: TextStyle(fontSize: 20),
                // ),
                // SizedBox(height: 10),

                // Text(
                //   'Join one of the existing groups.',
                //   style: TextStyle(fontSize: 20),
                // ),
                // SizedBox(height: 10),

                Container(
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 0, 116, 52),
                        Color.fromARGB(255, 0, 92, 41),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    border: Border.all(color: Color.fromARGB(255, 2, 47, 64), width: 1),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          )),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Create a new group",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.format_list_bulleted_add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 0, 116, 52),
                        Color.fromARGB(255, 0, 92, 41),

                        // Color.fromARGB(255, 0, 92, 41), Color.fromARGB(255, 0, 180, 81),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    border: Border.all(color: Color.fromARGB(255, 30, 77, 60), width: 1),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => const GroupListScreen(),
                      //   ),
                      // );
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        )),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Join an existing group",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.group_add_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                UserGroups()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
