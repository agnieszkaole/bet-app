import 'dart:async';
import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/user_groups.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SelectCriteriaScreen extends StatefulWidget {
  const SelectCriteriaScreen({
    super.key,
  });

  @override
  State<SelectCriteriaScreen> createState() => _SelectCriteriaScreenState();
}

class _SelectCriteriaScreenState extends State<SelectCriteriaScreen> {
  // String? selectedLeagueNumber;
  // String? selectedLeagueName;
  User? user = Auth().currentUser;
  // bool? isAnonymous = true;
  // bool? isUsernameModify = false;
  String? username;
  String? selectedLeagueNumber;
  bool isSelectedLeague = false;
  late Future<List<Map<String, dynamic>>> userGroupsFuture;

  @override
  void initState() {
    super.initState();
    initUserDetails();
    selectedLeagueNumber = '4';
    isSelectedLeague = true;
    userGroupsFuture = Groups().getUserGroupsData();
  }

  Future<void> initUserDetails() async {
    User? user = Auth().currentUser;
    if (user != null) {
      // isAnonymous = user.isAnonymous;
    }
    String? initialUsername = await UserData().getUserDataFromFirebase();

    setState(() {
      username = initialUsername;
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        UserData().getUserDataFromFirebase().then((newUsername) {
          setState(() {
            username = newUsername;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
    // String? matchId;
    // nextMatchesList.forEach((match) {
    //   matchId = match.fixture.id.toString();
    // });

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(25),
                    // border: Border.all(
                    //   width: 1,
                    //   color: const Color.fromARGB(170, 62, 155, 19),
                    // ),
                    // color: const Color.fromARGB(20, 0, 0, 0),
                    // gradient: const LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     Color.fromARGB(120, 62, 155, 19),
                    //     Color.fromARGB(120, 31, 77, 10),
                    //   ],
                    // ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.4),
                    //     offset: Offset(6.0, 6.0),
                    //     blurRadius: 10.0,
                    //   ),
                    // ],
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hello ${username != null ? '$username' : ''}',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          '   👋',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Text(
                      //   '⭐️   ',
                      //   style: TextStyle(fontSize: 16),
                      // ),
                      // Text(
                      //   'Your groups',
                      //   style: TextStyle(fontSize: 22),
                      // ),
                    ],
                  ),
                  Text(
                    'Choose one of your groups and start betting.',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: userGroupsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      // height: 200,
                      width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.only(left: 5, top: 10, right: 15, bottom: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(118, 48, 48, 48),
                        // border: Border.all(width: 0.8, color: Color.fromARGB(215, 69, 167, 24)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        children: [
                          const Text('You are not a member of any group yet.'),
                          const Text('Create a new group or join to existing one.'),
                          const SizedBox(height: 15),
                          const Text(
                            '👇',
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              Provider.of<BottomNavigationProvider>(context, listen: false).updateIndex(1);
                            },
                            child: Container(
                              width: 180,
                              height: 50,
                              // margin: const EdgeInsets.all(15),
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
                                color: const Color(0xFF292D32),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: const Center(
                                child: Text(
                                  'Groups',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    List<Map<String, dynamic>> userGroups = snapshot.data!;
                    return UserGroups(userGroups: userGroups);
                  }
                },
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upcoming matches',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: leagueNames.length,
                        itemBuilder: (context, index) {
                          var league = leagueNames[index];
                          return GestureDetector(
                            // key: Key(league["number"].toString()),
                            child: Container(
                                // width: 220,
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                      ? Border.all(width: 1, color: AppColors.green)
                                      : Border.all(width: 0.5, color: AppColors.greenDark),
                                  color: isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                      ? AppColors.greenDark
                                      : const Color.fromARGB(57, 80, 80, 80),
                                ),
                                child: Center(
                                  child: Text(
                                    league["name"],
                                    style: TextStyle(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        fontWeight:
                                            isSelectedLeague && selectedLeagueNumber == league['number'].toString()
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            onTap: () {
                              setState(() {
                                selectedLeagueNumber = league['number'].toString();
                                isSelectedLeague = true;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NextMatchList(
                      leagueNumber: selectedLeagueNumber,
                      isSelectedLeague: isSelectedLeague,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
