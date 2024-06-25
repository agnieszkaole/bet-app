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
              height: membersList.length > 3 ? 200 : 120,
              child: RawScrollbar(
                controller: _scrollController,
                interactive: true,
                trackColor: const Color.fromARGB(43, 40, 122, 43),
                thumbColor: const Color.fromARGB(255, 4, 109, 10),
                radius: const Radius.circular(10),
                thumbVisibility: true,
                trackVisibility: true,
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
                            height: 22,
                            margin: const EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    memberUsername ?? '',
                                    style: const TextStyle(fontSize: 16),
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
