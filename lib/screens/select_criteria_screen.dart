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
    GetApiData getApiDataScreen =
        GetApiData(leagueNumber: selectedLeagueNumber);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => getApiDataScreen),
    );
    // GetApiData(leagueNumber: selectedLeagueNumber);
  }

  void navigateToNextMatchList(String leagueName) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NextMatchList(leagueName: leagueName),
    ));
  }

  // void onTapLeague(String leagueNumber) {
  //   setState(() {
  //     selectedLeagueNumber = leagueNumber;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bet&win',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          const Text(
            'Wybierz ligę',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 1.5,
                // childAspectRatio: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
              ),
              children: [
                for (final league in leagueNames)
                  Card(
                    child: InkWell(
                      onTap: () async {
                        String leagueNumber = league['number'].toString();
                        String leagueName = league['name'].toString();
                        updateLeagueNumber(leagueNumber);
                        // onTapLeague(leagueNumber);
                        navigateToNextMatchList(leagueName);

                        // context.read<BottomNavigationProvider>().updateIndex(1);
                      },
                      borderRadius: BorderRadius.circular(24),
                      splashColor: const Color.fromARGB(207, 1, 2, 1),
                      child: Ink(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: cardColor,
                        ),
                        child: Center(
                          child: Text(
                            league["name"],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
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
  // Navigator.of(
                          //   context,
                          // ).pushNamed(
                          //   '/home',
                          //   arguments: leagueNumberSelect,
                          // );