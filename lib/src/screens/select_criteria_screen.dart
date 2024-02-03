import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/api_data.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:bet_app/src/constants/league_names.dart';

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
  String? selectedLeagueNumber;
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

  void updateLeagueNumber(String? newLeagueNumber) {
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                user?.displayName != null
                    ? 'Witaj ${user?.displayName}'
                    : 'Witaj',
                style: TextStyle(fontSize: 35),
              ),
              const Divider(
                height: 50,
                color: Color.fromARGB(150, 76, 175, 79),
                thickness: 1,
              ),
              const Text(
                'Wybierz ligę do wytypowania',
                // 'Select a league to bet',

                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Container(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final league in leagueNames)
                      Container(
                        width: 160,
                        margin: EdgeInsets.all(4),
                        child: Card(
                          color: const Color.fromARGB(255, 40, 122, 43),
                          child: InkWell(
                            onTap: () async {
                              String leagueNumber = league['number'].toString();
                              String leagueName = league['name'].toString();
                              String leagueLogo = league['logo'].toString();
                              updateLeagueNumber(leagueNumber);
                              navigateToNextMatchList(leagueName, leagueLogo);
                            },
                            borderRadius: BorderRadius.circular(8),
                            splashColor: const Color.fromARGB(207, 1, 2, 1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Image.network(
                                    league['logo'],
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                                ),
                                SizedBox(height: 10),
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
              Divider(
                height: 50,
                color: Color.fromARGB(150, 76, 175, 79),
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
