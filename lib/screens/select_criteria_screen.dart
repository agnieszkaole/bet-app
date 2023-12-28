import "package:bet_app/models/soccermodel.dart";
import "package:bet_app/screens/ranking_screen.dart";
import "package:bet_app/services/get_api_data.dart";
import "package:bet_app/widgets/next_match_list.dart";
import "package:flutter/material.dart";
import "package:bet_app/constants/league_names.dart";

class SelectCriteriaScreen extends StatefulWidget {
  const SelectCriteriaScreen({super.key});

  @override
  State<SelectCriteriaScreen> createState() => _SelectCriteriaScreenState();
}

class _SelectCriteriaScreenState extends State<SelectCriteriaScreen> {
  // late final List<SoccerMatch> dataFromApi;
  var cardColor = const Color.fromARGB(255, 40, 122, 43);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                childAspectRatio: 3 / 1.3,
                // childAspectRatio: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
              ),
              children: [
                for (final league in leagueNames)
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: InkWell(
                      onTap: () {
                        var leagueNumber = league['number'];
                        var leagueName = league['name'];
                        final leagueNumberSelect = leagueNumber.toString();
                        Navigator.of(context).pushNamed(
                          '/home',
                          arguments: leagueNumberSelect,
                        );
                      },
                      borderRadius: BorderRadius.circular(24),
                      splashColor: Color.fromARGB(207, 1, 2, 1),
                      child: Ink(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
              ]),
        )
      ],
    );
  }
}
  // var value1 = false;
  // var value2 = false;
  // var value3 = false;
  // var value4 = false;
  // var value5 = false;
  // var value6 = false;
  // var value7 = false;
  // var value8 = false;
  // var value9 = false;
  // var value10 = false;
  // var value11 = false;
  // var value12 = false;
  // var value13 = false;
  // var value14 = false;
  // var value15 = false;

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: Column(children: [
  //       const Text('Wybierz ligę', style: TextStyle(fontSize: 20)),
  //       Expanded(
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           child: Column(
  //             children: [
  //               SwitchListTile(
  //                 value: value1,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value1 = newValue;
  //                   });
  //                 },
  //                 title: Text("PKO BP Ekstraklasa"),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value2,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value2 = newValue;
  //                   });
  //                 },
  //                 title: Text('Fortuna 1 Liga'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value3,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value3 = newValue;
  //                   });
  //                 },
  //                 title: Text('Fortuna Puchar Polski'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value4,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value4 = newValue;
  //                   });
  //                 },
  //                 title: Text('Mistrzosta Europy'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value5,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value5 = newValue;
  //                   });
  //                 },
  //                 title: Text('Mistrzosta Europy - kwalifikacje'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value6,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value6 = newValue;
  //                   });
  //                 },
  //                 title: Text('Mistrzostwa Świata'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value7,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value7 = newValue;
  //                   });
  //                 },
  //                 title: Text('Liga Mistrzów'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value8,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value8 = newValue;
  //                   });
  //                 },
  //                 title: Text('Premier League'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value9,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value9 = newValue;
  //                   });
  //                 },
  //                 title: Text('Ligue 1'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value10,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value10 = newValue;
  //                   });
  //                 },
  //                 title: Text('La Liga'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value11,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value11 = newValue;
  //                   });
  //                 },
  //                 title: Text('Bundesliga'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value12,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value12 = newValue;
  //                   });
  //                 },
  //                 title: Text('Serie A'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value13,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value13 = newValue;
  //                   });
  //                 },
  //                 title: Text('Liga Europy'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value14,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value14 = newValue;
  //                   });
  //                 },
  //                 title: Text('Liga Konferencji Europy'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //               SwitchListTile(
  //                 value: value15,
  //                 onChanged: (bool newValue) {
  //                   setState(() {
  //                     value15 = newValue;
  //                   });
  //                 },
  //                 title: Text('Liga Narodów UEFA'),
  //                 contentPadding: const EdgeInsets.only(left: 34, right: 22),
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //     ]),
  //   );
  // }

