import "package:bet_app/src/models/soccermodel.dart";
import "package:bet_app/src/services/groups.dart";
import "package:bet_app/src/widgets/group_details.dart";
import "package:bet_app/src/widgets/group_match_list.dart";
import "package:bet_app/src/widgets/group_table.dart";
import "package:bet_app/src/widgets/predicted_matches_firebase.dart";
import "package:flutter/material.dart";

class GroupTabs extends StatefulWidget {
  const GroupTabs(
      {super.key,
      this.groupId,
      this.groupName,
      this.groupMembers,
      this.creatorUsername,
      this.privacyType,
      this.matches});

  final String? groupId;
  final String? groupName;
  final String? creatorUsername;
  final String? privacyType;
  final int? groupMembers;
  final List<SoccerMatch>? matches;

  @override
  State<GroupTabs> createState() => _GroupTabsState();
}

class _GroupTabsState extends State<GroupTabs> {
  Groups groups = Groups();
  String? selectedLeagueName = '';
  int? selectedLeagueNumber;
  Map<String, dynamic> selectedLeague = {};

  @override
  void initState() {
    super.initState();
    getLeagueInfo();
  }

  Future<void> getLeagueInfo() async {
    try {
      Map<String, dynamic>? result =
          await groups.getDataAboutGroup(widget.groupId!);

      setState(() {
        selectedLeague = result['selectedLeague'];
        selectedLeagueName = selectedLeague['leagueName'];
        selectedLeagueNumber = selectedLeague['leagueNumber'];
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          // title: Text('Grupa:  $groupName'),
          title: Row(
            children: [
              Text(
                '${widget.groupName} ',
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                '( ${widget.groupMembers} ',
                style: const TextStyle(fontSize: 22),
              ),
              const Icon(Icons.person, size: 22),
              Text(
                ' )',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          bottom: const PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Column(
              children: [
                // SizedBox(height: 15),
                TabBar(
                  tabAlignment: TabAlignment.center,
                  padding: EdgeInsets.only(bottom: 10),
                  indicatorColor: Colors.green,
                  indicatorWeight: 2.0,
                  labelColor: Colors.white,
                  dividerColor: Color.fromARGB(38, 255, 255, 255),
                  tabs: [
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline_rounded, size: 20),
                          SizedBox(width: 3),
                          Text(
                            'Info',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.emoji_events_rounded, size: 25),
                          Icon(Icons.scoreboard_outlined, size: 20),
                          // Icon(Icons.view_array_rounded, size: 25),
                          SizedBox(width: 3),
                          Text(
                            'Matches',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.emoji_events_rounded, size: 25),
                          Icon(Icons.scoreboard_outlined, size: 20),
                          // Icon(Icons.view_array_rounded, size: 25),
                          SizedBox(width: 3),
                          Text(
                            'Predictions',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.emoji_events_rounded, size: 25),
                          Icon(Icons.sports_soccer_rounded, size: 20),
                          // Icon(Icons.view_array_rounded, size: 25),
                          SizedBox(width: 3),
                          Text(
                            'Table',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // Tab(
                    //   iconMargin: EdgeInsets.zero,
                    //   icon: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Icon(Icons.sort_rounded, size: 25),
                    //       // Icon(Icons.workspace_premium_rounded, size: 25),
                    //       SizedBox(width: 3),
                    //       Text('Ranking'),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GroupDetails(
              groupId: widget.groupId,
              groupName: widget.groupName,
              groupMembers: widget.groupMembers,
              privacyType: widget.privacyType,
              creatorUsername: widget.creatorUsername,
              selectedLeagueName: selectedLeagueName,
            ),
            GroupMatchList(
              // leagueNumber: selectedLeagueNumber == '4'
              //     ? '4'
              //     : selectedLeagueNumber.toString(),
              // leagueName: selectedLeagueName,
              leagueNumber: selectedLeagueNumber.toString(),
              leagueName: selectedLeagueName.toString(),
            ),
            const PredictedMatchesFirebase(),
            const GroupTable(),
            // Center(child: const Text('Ranking')),
          ],
        ),
      ),
    );
  }
}
