import "package:bet_app/src/screens/next_matches_screen.dart";
import "package:bet_app/src/widgets/group_details.dart";
import "package:bet_app/src/widgets/group_match_list.dart";
import "package:bet_app/src/widgets/group_table.dart";
import "package:bet_app/src/widgets/next_match_list.dart";
import "package:flutter/material.dart";

class GroupTabs extends StatelessWidget {
  const GroupTabs({
    super.key,
    this.groupId,
    this.groupName,
    this.groupMembers,
    this.creatorUsername,
    this.privacyType,
  });

  final String? groupId;
  final String? groupName;
  final String? creatorUsername;
  final String? privacyType;
  final int? groupMembers;

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
                '${groupName} ',
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                '( ${groupMembers} ',
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
                          Icon(Icons.info_outline_rounded, size: 25),
                          SizedBox(width: 5),
                          Text('Info'),
                        ],
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.emoji_events_rounded, size: 25),
                          Icon(Icons.scoreboard_outlined, size: 25),
                          // Icon(Icons.view_array_rounded, size: 25),
                          SizedBox(width: 5),
                          Text('Mecze'),
                        ],
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.emoji_events_rounded, size: 25),
                          Icon(Icons.sports_soccer_rounded, size: 25),
                          // Icon(Icons.view_array_rounded, size: 25),
                          SizedBox(width: 5),
                          Text('Tabela'),
                        ],
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sort_rounded, size: 25),
                          // Icon(Icons.workspace_premium_rounded, size: 25),
                          SizedBox(width: 5),
                          Text('Ranking'),
                        ],
                      ),
                    ),
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
                groupId: groupId,
                groupName: groupName,
                groupMembers: groupMembers,
                privacyType: privacyType,
                creatorUsername: creatorUsername),
            // const Text('yuiytuiyuiytuityuitu'),
            GroupMatchList(),
            const GroupTable(),
            const Text('yuiytuiyuiytuityuitu'),
          ],
        ),
      ),
    );
  }
}
