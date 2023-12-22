import "package:bet_app/models/soccermodel.dart";
import "package:flutter/material.dart";

class SelectCriteriaScreen extends StatefulWidget {
  const SelectCriteriaScreen({
    super.key,
  });

  @override
  State<SelectCriteriaScreen> createState() => _SelectCriteriaScreenState();
}

class _SelectCriteriaScreenState extends State<SelectCriteriaScreen> {
  late final List<SoccerMatch> dataFromApi;
  bool? isSelected;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const Text('Wybierz ligę', style: TextStyle(fontSize: 20)),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('PKO BP Ekstraklasa'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Fortuna 1 Liga'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Fortuna Puchar Polski'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Mistrzosta Europy'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Mistrzostwa Świata'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Liga Mistrzów'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Premier League'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Ligue 1'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('La Liga'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Bundesliga'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Serie A'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Liga Europy'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Liga Konferencji Europy'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (bool newValue) {
                    setState(() {
                      isSelected = newValue;
                    });
                  },
                  title: Text('Liga Narodów UEFA'),
                  contentPadding: const EdgeInsets.only(left: 34, right: 22),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
