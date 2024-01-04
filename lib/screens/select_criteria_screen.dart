import "package:bet_app/provider/bottom_navigation_provider.dart";
import "package:bet_app/provider/next_matches_provider.dart";
import "package:bet_app/services/get_api_data.dart";
import "package:bet_app/widgets/main_drawer.dart";
import "package:bet_app/widgets/next_match_list.dart";
import "package:flutter/material.dart";
import "package:bet_app/constants/league_names.dart";
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
      appBar: AppBar(
        title: const Text(
          'Bet',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          const Text(
            'Wybierz ligę do wytypowania',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCount: 2,
              // childAspectRatio: 3 / 1.5,
              // childAspectRatio: 5,
              // crossAxisSpacing: 10,
              // mainAxisSpacing: 10,
              // ),
              children: [
                for (final league in leagueNames)
                  Container(
                    margin: EdgeInsets.all(4),
                    child: Card(
                      color: const Color.fromARGB(255, 40, 122, 43),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: InkWell(
                          onTap: () async {
                            String leagueNumber = league['number'].toString();
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                league["name"],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
