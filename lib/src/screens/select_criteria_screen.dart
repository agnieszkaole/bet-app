import 'package:bet_app/src/screens/join_existing_group_screen.dart';
import 'package:bet_app/src/screens/new_group_screen.dart';
import 'package:bet_app/src/services/auth.dart';

import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:bet_app/src/constants/league_names.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SelectCriteriaScreen extends StatefulWidget {
  const SelectCriteriaScreen({
    super.key,
  });

  @override
  State<SelectCriteriaScreen> createState() => _SelectCriteriaScreenState();
}

class _SelectCriteriaScreenState extends State<SelectCriteriaScreen> {
  int currentPage = 0;
  var cardColor = const Color.fromARGB(255, 40, 122, 43);
  int? selectedLeagueNumber;
  String? selectedLeagueName;
  User? user = Auth().currentUser;
  bool? isAnonymous = true;
  String? username = '';

  @override
  void initState() {
    super.initState();
    initUserDetails();
  }

  Future<void> initUserDetails() async {
    setState(() {
      User? user = Auth().currentUser;
      if (user != null) {
        isAnonymous = user.isAnonymous;
      }
    });
    username = await UserData().getUsernameFromFirebase();
    setState(() {});
  }

  void navigateToNextMatchList(String leagueName, String leagueLogo) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          NextMatchList(leagueName: leagueName, leagueLogo: leagueLogo),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: isAnonymous == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Witaj',
                      style: TextStyle(fontSize: 35),
                    ),
                    const Divider(
                      height: 50,
                      color: Color.fromARGB(150, 76, 175, 79),
                      thickness: 1,
                    ),
                    const Text(
                      'Wybierz ligę do wytypowania',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final league in leagueNames)
                            Container(
                              width: 160,
                              margin: const EdgeInsets.all(4),
                              child: Card(
                                // color: const Color.fromARGB(255, 40, 122, 43),
                                child: InkWell(
                                  onTap: () async {
                                    int leagueNumber = league['number'];
                                    String leagueName =
                                        league['name'].toString();
                                    String leagueLogo =
                                        league['logo'].toString();
                                    // updateLeagueNumber(leagueNumber);
                                    navigateToNextMatchList(
                                        leagueName, leagueLogo);
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  splashColor:
                                      const Color.fromARGB(207, 1, 2, 1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: Image.network(
                                          league['logo'],
                                          width: 60.0,
                                          height: 60.0,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 35,
                                        child: Text(
                                          league["name"],
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 50,
                      color: Color.fromARGB(150, 76, 175, 79),
                      thickness: 1,
                    ),
                  ],
                )

              ////////////////  Loggin ////////////////////////
              : Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello ${user?.displayName}',
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Let\'s start betting with your friends. 🖐',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // SvgPicture.asset(
                    //   'assets/images/undraw_team_re_0bfe.svg',
                    // ),
                    // Image.asset(
                    //   'assets/images/pexels-pixabay-47730.jpg',
                    // ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 0.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 37, 37, 37),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            offset: Offset(5.0, 5.0),
                          )
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            // Color.fromARGB(255, 0, 32, 128),
                            Color.fromARGB(255, 0, 90, 58),
                            Color.fromARGB(255, 0, 128, 53),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "We cover the best football leagues",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(
                            height: 20,
                            color: Color.fromARGB(255, 40, 122, 43),
                            thickness: 1.8,
                            indent: 50,
                            endIndent: 50,
                          ),
                          Container(
                            height: 135,
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 0.28,
                                // autoPlay: true,
                                // autoPlayInterval: Duration(seconds: 5),
                                // autoPlayAnimationDuration:
                                //     Duration(milliseconds: 800),
                                // autoPlayCurve: Curves.fastOutSlowIn,

                                scrollDirection: Axis.horizontal,
                              ),
                              items: leagueNames.map((league) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin: const EdgeInsets.all(4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 70,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            child: Image.network(
                                              league['logo'],
                                              width: 65.0,
                                              height: 65.0,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            height: 35,
                                            width: 120,
                                            child: Text(
                                              league["name"],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // const Text(
                    //   "Create a new group and invite your friends or join an existing one.",
                    //   style: TextStyle(fontSize: 18, color: Colors.white),
                    //   textAlign: TextAlign.left,
                    // ),
                    const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       width: 160,
                    //       height: 110,
                    //       child: ElevatedButton(
                    //           onPressed: () {
                    //             Navigator.of(context).push(
                    //               MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     const NewGroupScreen(),
                    //               ),
                    //             );
                    //           },
                    //           style: ButtonStyle(
                    //               padding: MaterialStatePropertyAll(
                    //                   EdgeInsets.all(10)),
                    //               backgroundColor:
                    //                   MaterialStateProperty.all<Color>(
                    //                       Color.fromARGB(255, 0, 64, 128)),
                    //               shape: const MaterialStatePropertyAll(
                    //                   RoundedRectangleBorder(
                    //                       borderRadius: BorderRadius.all(
                    //                 Radius.circular(12),
                    //               ))),
                    //               side: const MaterialStatePropertyAll(
                    //                 BorderSide(
                    //                     color: Color.fromARGB(255, 30, 77, 60),
                    //                     width: 1),
                    //               )),
                    //           child: const Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 "Create a new group",
                    //                 style: TextStyle(
                    //                     fontSize: 14, color: Colors.white),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //               Icon(
                    //                 Icons.format_list_bulleted_add,
                    //                 color: Colors.white,
                    //                 size: 35,
                    //               ),
                    //             ],
                    //           )),
                    //     ),
                    //     const SizedBox(width: 20),

                    //     // Icon(
                    //     //   Icons.group_add_rounded,
                    //     //   color: Colors.white,
                    //     //   size: 35,
                    //     // ),
                    //     Container(
                    //       width: 160,
                    //       height: 110,
                    //       child: OutlinedButton(
                    //         onPressed: () {
                    //           Navigator.of(context).push(
                    //             MaterialPageRoute(
                    //               builder: (context) => const GroupListScreen(),
                    //             ),
                    //           );
                    //         },
                    //         style: ButtonStyle(
                    //             padding: MaterialStatePropertyAll(
                    //                 EdgeInsets.all(10)),
                    //             backgroundColor:
                    //                 MaterialStateProperty.all<Color>(
                    //                     Color.fromARGB(255, 0, 90, 58)),
                    //             shape: const MaterialStatePropertyAll(
                    //                 RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.all(
                    //               Radius.circular(12),
                    //             ))),
                    //             side: const MaterialStatePropertyAll(
                    //               BorderSide(
                    //                   color: Color.fromARGB(255, 30, 77, 60),
                    //                   width: 1),
                    //             )),
                    //         child: const Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               "Join an existing group",
                    //               style: TextStyle(
                    //                   fontSize: 14, color: Colors.white),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //             Icon(
                    //               Icons.group_add_rounded,
                    //               color: Colors.white,
                    //               size: 35,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.all(20),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     border: Border.all(width: 0.5),
                    //     boxShadow: const [
                    //       BoxShadow(
                    //         color: Color.fromARGB(255, 36, 36, 36),
                    //         blurRadius: 10.0, // Soften the shaodw
                    //         spreadRadius: 2.0,
                    //         offset: Offset(5.0, 5.0),
                    //       )
                    //     ],
                    //     // color: Color.fromARGB(180, 41, 41, 41),
                    //     gradient: const LinearGradient(
                    //       begin: Alignment.topRight,
                    //       end: Alignment.bottomLeft,
                    //       colors: [
                    //         // Color.fromARGB(255, 0, 83, 32),
                    //         // Color.fromARGB(255, 76, 128, 66),

                    //         Color.fromARGB(255, 0, 128, 53),
                    //         Color.fromARGB(255, 0, 90, 58),
                    //       ],
                    //     ),
                    //   ),
                    //   child: const Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         'Are you already a member of any group?',
                    //         style: TextStyle(fontSize: 17),
                    //       ),
                    //       SizedBox(height: 5),
                    //       Text(
                    //         'Great! Check details in the Groups tab.',
                    //         style: TextStyle(fontSize: 17),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
        ),
      ),
    );
  }
}
