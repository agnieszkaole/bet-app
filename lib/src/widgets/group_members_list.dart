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
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.green, width: 1),
              //     borderRadius: BorderRadius.circular(10)),
              height: 200,
              child: ListView.builder(
                  itemCount: membersList.length,
                  itemBuilder: (context, index) {
                    final member = membersList[index];
                    String? memberUsername = member['memberUsername'];

                    return Column(
                      children: [
                        SizedBox(
                          height: 30,
                          child: ListTile(
                            title: Row(
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
                            // trailing: widget.creatorUsername == memberUsername
                            //     ? const SizedBox()
                            //     : GestureDetector(
                            //         onTap: () {
                            //           showDialog(
                            //             context: context,
                            //             builder: (BuildContext context) {
                            //               return AlertDialog(
                            //                 title: Text(
                            //                   "Delete member",
                            //                   style: TextStyle(fontSize: 16),
                            //                 ),
                            //                 content:
                            //                     Text('Are you sure you want to remove this user from the group?'),
                            //                 actions: [
                            //                   Column(
                            //                     children: [
                            //                       Row(
                            //                         mainAxisAlignment: MainAxisAlignment.end,
                            //                         children: [
                            //                           TextButton(
                            //                             onPressed: () {
                            //                               Navigator.of(context).pop();
                            //                             },
                            //                             child: const Text(
                            //                               'No',
                            //                               style: TextStyle(
                            //                                 color: Colors.white,
                            //                                 fontWeight: FontWeight.bold,
                            //                               ),
                            //                             ),
                            //                           ),
                            //                           TextButton(
                            //                             onPressed: () async {
                            //                               // groups.deleteMemberFromGroup(
                            //                                   // widget.groupId, memberUsername);

                            //                               Navigator.of(context).pop();
                            //                             },
                            //                             child: const Text(
                            //                               'Yes',
                            //                               style: TextStyle(
                            //                                 color: Colors.red,
                            //                                 fontWeight: FontWeight.bold,
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ],
                            //                       )
                            //                     ],
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // },
                            // child: Icon(
                            //   Icons.group_remove_rounded,
                            //   size: 30,
                            // ),
                          ),
                          // ),
                        ),
                      ],
                    );
                  }),
            );
          }
        });
  }
}
