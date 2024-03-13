import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';

class GroupMembersList extends StatefulWidget {
  const GroupMembersList({super.key, required this.groupId, required this.creatorUsername});

  final String groupId;
  final String creatorUsername;

  @override
  State<GroupMembersList> createState() => _GroupMembersListState();
}

class _GroupMembersListState extends State<GroupMembersList> {
  Groups groups = Groups();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: groups.getDataAboutGroup(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(width: 30, height: 30, child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text(
              'Nie można pobrać listy użytkowników',
              style: TextStyle(fontSize: 18),
            );
          } else {
            Map<String, dynamic>? groupData = snapshot.data ?? {};
            List<Map<String, dynamic>> membersList = groupData['members'] ?? [];

            return Container(
              height: 100,
              child: ListView.builder(
                  itemCount: membersList.length,
                  itemBuilder: (context, index) {
                    final member = membersList[index];
                    String? memberUsername = member['memberUsername'];
                    return Column(
                      children: [
                        SizedBox(
                          height: 25,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  memberUsername ?? '',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(width: 10),
                                widget.creatorUsername == memberUsername
                                    ? const Icon(Icons.admin_panel_settings_rounded)
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }
        });
  }
}
