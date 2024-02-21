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
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 300,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const NewGroupScreen(),
                        //   ),
                        // );
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
                      style: ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 30)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 64, 128)),
                          shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ))),
                          side: const MaterialStatePropertyAll(
                            BorderSide(color: Color.fromARGB(255, 30, 77, 60), width: 1),
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
                const SizedBox(height: 15),
                Container(
                  width: 300,
                  height: 60,
                  child: OutlinedButton(
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
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 30)),
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 2, 143, 65)),
                        shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ))),
                        side: const MaterialStatePropertyAll(
                          BorderSide(color: Color.fromARGB(255, 30, 77, 60), width: 1),
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
                SizedBox(height: 20),
                UserGroups()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
