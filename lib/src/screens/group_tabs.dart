import "package:bet_app/src/models/soccermodel.dart";
import "package:bet_app/src/provider/next_matches_provider.dart";
import 'package:bet_app/src/provider/scoreboard_provider.dart';
import "package:bet_app/src/services/groups.dart";
import "package:bet_app/src/services/soccer_api.dart";
import "package:bet_app/src/widgets/group_details.dart";
import "package:bet_app/src/widgets/group_match_list.dart";
import "package:bet_app/src/widgets/group_table.dart";
import "package:bet_app/src/widgets/match_scheduled.dart";
import "package:bet_app/src/widgets/predicted_matches_firebase.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

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

  get leagueNumber => null;

  @override
  State<GroupTabs> createState() => _GroupTabsState();
}

class _GroupTabsState extends State<GroupTabs> {
  Groups groups = Groups();
  String? selectedLeagueName = '';
  int? selectedLeagueNumber;
  Map<String, dynamic> selectedLeague = {};
  Timestamp? createdAt;
  DateTime? createdAtDate;
  String? formattedCreatedAtDate;

  // int? uniqueId;

  @override
  void initState() {
    super.initState();
    getGroupInfo();
  }

  // void _formatDate() {
  // createdAtDate = createdAt!.toDate();
  // formattedCreatedAtDate = DateFormat('yyyy-MM-dd').format(createdAtDate!);
  // }

  Future<void> getGroupInfo() async {
    try {
      Map<String, dynamic>? result = await groups.getDataAboutGroup(widget.groupId!);

      setState(() {
        selectedLeague = result['selectedLeague'];
        selectedLeagueName = selectedLeague['leagueName'];
        selectedLeagueNumber = selectedLeague['leagueNumber'];
        createdAt = result['createdAt'];

        if (createdAt != null) {
          createdAtDate = createdAt!.toDate();
          formattedCreatedAtDate = DateFormat('yyyy-MM-dd').format(createdAtDate!);
        }
      });

      // _formatDate();

      // _formatDate();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ScoreboardProvider>(context, listen: false).clearMatches();
        return true;
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // title: Text('Grupa:  $groupName'),
            title: Row(
              children: [
                Container(
                  width: 280,
                  child: Text(
                    '${widget.groupName} ',
                    style: const TextStyle(fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Text(
                //   '( ${widget.groupMembers} ',
                //   style: const TextStyle(fontSize: 22),
                // ),
                // const Icon(Icons.person, size: 22),
                // Text(
                //   ' )',
                //   style: const TextStyle(fontSize: 20),
                // ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Column(
                children: [
                  const TabBar(
                    tabAlignment: TabAlignment.center,
                    padding: EdgeInsets.only(bottom: 10),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.green,
                    indicatorWeight: 1.2,
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
                            Icon(Icons.sports_soccer_rounded, size: 20),
                            SizedBox(width: 3),
                            Text(
                              'Scheduled',
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
                            Icon(Icons.scoreboard_outlined, size: 20),
                            SizedBox(width: 3),
                            Text(
                              'Predicted',
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
                            Icon(Icons.handshake, size: 20),
                            SizedBox(width: 3),
                            Text(
                              'Bets',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Center(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GroupDetails(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  groupMembers: widget.groupMembers,

                  privacyType: widget.privacyType,
                  creatorUsername: widget.creatorUsername,
                  selectedLeagueName: selectedLeagueName,
                  createdAt: formattedCreatedAtDate,

                  // uniqueId: uniqueIdg
                ),
                MatchScheduled(
                  leagueNumber: selectedLeagueNumber.toString(),
                  leagueName: selectedLeagueName.toString(),
                ),
                PredictedMatchesFirebase(
                  leagueNumber: selectedLeagueNumber,
                ),
                GroupTable(
                  createdAt: createdAt,
                  leagueNumber: selectedLeagueNumber.toString(),
                  groupId: widget.groupId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
