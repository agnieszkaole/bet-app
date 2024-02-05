import 'package:bet_app/src/screens/join_existing_group_screen.dart';
import 'package:bet_app/src/screens/new_group_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/api_data.dart';
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

  void updateLeagueNumber(int? newLeagueNumber) {
    setState(() {
      selectedLeagueNumber = newLeagueNumber;
    });

    ApiData getApiDataScreen = ApiData(leagueNumber: selectedLeagueNumber);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => getApiDataScreen),
    );
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
                  // mainAxisAlignment: MainAxisAlignment.start,
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
                                    updateLeagueNumber(leagueNumber);
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
              : Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello ${user?.displayName},',
                            style: const TextStyle(fontSize: 40),
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
                    //   width: 150,
                    // ),
                    // Image.asset(
                    //   'assets/images/pexels-pixabay-47730.jpg',
                    //   width: 200,
                    // ),
                    // const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromARGB(180, 41, 41, 41),
                      ),
                      child: Column(
                        children: [
                          // const Divider(
                          //   height: 30,
                          //   color: Color.fromARGB(150, 76, 175, 79),
                          //   thickness: 2,
                          //   endIndent: 50,
                          //   indent: 50,
                          // ),
                          const Text(
                            "Which event are you interested in?",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            " Check out what we've got.",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 140,
                            width: double.infinity,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 0.35,
                                initialPage: 2,
                                enlargeFactor: 0.5,
                                // reverse: false,
                                // autoPlay: true,
                                // autoPlayInterval: Duration(seconds: 3),
                                // autoPlayAnimationDuration:
                                //     Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                              items: leagueNames.map((league) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: 140,
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
                                            height: 40,
                                            width: 120,
                                            child: Text(
                                              league["name"],
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
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

                    // const Divider(
                    //   height: 30,
                    //   color: Color.fromARGB(150, 76, 175, 79),
                    //   thickness: 2,
                    //   endIndent: 50,
                    //   indent: 50,
                    // ),
                    const SizedBox(height: 20),
                    const Text(
                      "Create a group and invite your friends or join an existing one.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 310,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NewGroupScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                // shape: const StadiumBorder(),
                                // minimumSize: const Size(280, 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 40, 122, 43),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Create a new group",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 310,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const GroupListScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              // shape: const StadiumBorder(),
                              // minimumSize: const Size(300, 50),
                              side: const BorderSide(
                                width: 1.5,
                                color: Color.fromARGB(255, 40, 122, 43),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Join an existing group",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Icon(
                                  Icons.group_add_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // const Divider(
                    //   height: 30,
                    //   color: Color.fromARGB(150, 76, 175, 79),
                    //   thickness: 2,
                    //   endIndent: 50,
                    //   indent: 50,
                    // ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromARGB(180, 41, 41, 41),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Are you already a member of any group?',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Great! Check details in the Groups tab.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
