import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/provider/next_matches_provider.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/get_api_data.dart';
import 'package:bet_app/src/widgets/main_drawer.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:bet_app/src/constants/league_names.dart';
import "package:provider/provider.dart";

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
  String? username;
  bool? isAnomous = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      User? user = Auth().currentUser;
      if (user != null) {
        username = user.email ?? '';
        isAnomous = user.isAnonymous;
      }
    });
  }

  void updateLeagueNumber(String? newLeagueNumber) {
    setState(() {
      selectedLeagueNumber = newLeagueNumber;
    });
    // fetchDataForNewLeague(newLeagueNumber);
    GetApiData getApiDataScreen =
        GetApiData(leagueNumber: selectedLeagueNumber);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => getApiDataScreen),
    );
    // GetApiData(leagueNumber: selectedLeagueNumber);
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
                'Witaj',
                style: TextStyle(fontSize: 35),
              ),
              if (isAnomous == false)
                Text(
                  '$username',
                  style: TextStyle(fontSize: 20),
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
              SizedBox(height: 10),
              Container(
                height: 140,
                child: Expanded(
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
                                String leagueNumber =
                                    league['number'].toString();
                                String leagueName = league['name'].toString();
                                String leagueLogo = league['logo'].toString();
                                updateLeagueNumber(leagueNumber);
                                navigateToNextMatchList(leagueName, leagueLogo);

                                // context
                                //     .read<BottomNavigationProvider>()
                                //     .updateIndex(1);
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
                                      // color: Color.fromARGB(255, 169, 224, 172),
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
