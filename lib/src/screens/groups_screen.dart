import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/screens/new_group_screen.dart';
import 'package:bet_app/src/screens/join_existing_group_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

typedef OnGroupCreatedCallback = void Function();

class _GroupsScreenState extends State<GroupsScreen> {
  void _refreshUserGroups() {
    if (mounted) {
      setState(() {});
    }
  }

  User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          // width: double.infinity,
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // const SizedBox(height: 20),
              // Container(
              //   // width: 350,
              //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(25),
              //     border: Border.all(
              //       width: 0.5,
              //       color: const Color.fromARGB(170, 62, 155, 19),
              //     ),
              //     // color: const Color.fromARGB(20, 0, 0, 0),
              //     gradient: const LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: [
              //         Color.fromARGB(120, 62, 155, 19),
              //         Color.fromARGB(120, 31, 77, 10),
              //       ],
              //     ),
              //   ),
              //   child: const Text(
              //     'How to bet?',
              //     style: TextStyle(fontSize: 20),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // const SizedBox(height: 15),
              // const Text(
              //   '👇',
              //   style: TextStyle(fontSize: 25),
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(height: 15),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                width: MediaQuery.of(context).size.width - 60,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(57, 80, 80, 80),
                  // color: Color.fromARGB(57, 58, 139, 21),
                  // border: Border.all(
                  //   width: .5,
                  //   color: const Color.fromARGB(224, 102, 102, 102),
                  // ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: const BoxDecoration(
                          // color: const Color.fromARGB(118, 51, 51, 51),
                          // border: Border.all(
                          //   width: .5,
                          //   color: const Color.fromARGB(224, 102, 102, 102),
                          // ),
                          // borderRadius: const BorderRadius.all(
                          //   Radius.circular(25),
                          // ),
                          ),
                      child: GestureDetector(
                        // onTap: () {
                        //   Navigator.of(context)
                        //       .push(MaterialPageRoute(
                        //     builder: (context) => const NewGroupScreen(),
                        //   ))
                        //       .then((value) {
                        //     if (value != null && value == true) {
                        //       setState(() {});
                        //     }
                        //   });
                        // },
                        onTap: () async {
                          final result = await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NewGroupScreen(),
                          ));
                          if (result != null && result == true && mounted) {
                            setState(() {});
                          }
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 260,
                              child: Text(
                                'Create a new group, select a\u{00A0}league and invite your friends (max. 10).',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 250,
                              height: 50,
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.greenDark,
                                boxShadow: [
                                  // BoxShadow(
                                  //   color: Colors.white.withOpacity(0.1),
                                  //   offset: Offset(-6.0, -6.0),
                                  //   blurRadius: 5.0,
                                  // ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    offset: const Offset(6.0, 6.0),
                                    blurRadius: 10.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: const Center(
                                  child: Text(
                                'Create',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: const BoxDecoration(
                          // border: Border.all(
                          //   width: .5,
                          //   color: const Color.fromARGB(224, 102, 102, 102),
                          // ),
                          // borderRadius: const BorderRadius.all(
                          //   Radius.circular(25),
                          // ),
                          // color: const Color.fromARGB(118, 51, 51, 51),
                          ),
                      // color: Color.fromARGB(255, 39, 39, 39)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => const GroupListScreen(),
                          ))
                              .then((value) {
                            if (value != null && value == true) {
                              setState(() {});
                            }
                          });
                          _refreshUserGroups();
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 250,
                              child: Text(
                                'Join one of the existing public or\u{00A0}private groups.',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 250,
                              height: 50,
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.greenDark,
                                boxShadow: [
                                  // BoxShadow(
                                  //   color: Colors.white.withOpacity(0.1),
                                  //   offset: Offset(-6.0, -6.0),
                                  //   blurRadius: 5.0,
                                  // ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    offset: const Offset(6.0, 6.0),
                                    blurRadius: 10.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: const Center(
                                  child: Text(
                                'Join',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // UserGroups(onGroupCreated: _refreshUserGroups),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
