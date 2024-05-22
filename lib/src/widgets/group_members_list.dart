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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: groups.getDataAboutGroup(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(width: 30, height: 30, child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text(
              'Nie można pobrać listy użytkowników',
              style: TextStyle(fontSize: 18),
            );
          } else {
            Map<String, dynamic>? groupData = snapshot.data ?? {};
            List<Map<String, dynamic>> membersList = groupData['members'] ?? [];

            return SizedBox(
              height: 180,
              child: Scrollbar(
                controller: _scrollController,
                trackVisibility: true,
                thumbVisibility: true,
                radius: const Radius.circular(10),
                thickness: 1,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: membersList.length,
                    itemBuilder: (context, index) {
                      final member = membersList[index];
                      String? memberUsername = member['memberUsername'];
                      return Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            margin: const EdgeInsets.only(bottom: 5),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    memberUsername ?? '',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  widget.creatorUsername == memberUsername
                                      // ? const Icon(Icons.admin_panel_settings_rounded)
                                      ? const Text(
                                          '⭐',
                                          style: TextStyle(fontSize: 16),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            );
          }
        });
  }
}
