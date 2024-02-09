import 'package:bet_app/src/widgets/group_members_list.dart';
import 'package:flutter/material.dart';

class GroupDetails extends StatefulWidget {
  const GroupDetails({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupMembers,
    required this.creatorUsername,
    required this.privacyType,
    this.selectedLeagueName,
  });
  final String? groupId;
  final String? groupName;
  final String? creatorUsername;
  final String? privacyType;
  final int? groupMembers;
  final String? selectedLeagueName;

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            Container(
              width: 300,
              // padding: const EdgeInsets.all(20),
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.green, width: 1),
              //     borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Group name',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${widget.groupName} ',
                                style: const TextStyle(fontSize: 26),
                              ),
                            ],
                          ),
                          Icon(Icons.edit_sharp),
                        ],
                      ),
                      const Divider(
                        height: 40,
                        color: Color.fromARGB(255, 40, 122, 43),
                        thickness: 1.2,
                        // indent: 20,
                        // endIndent: 20,
                      ),
                      Text(
                        'Selected league',
                        style: const TextStyle(fontSize: 14),
                        // textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3),
                      Text(
                        '${widget.selectedLeagueName}',
                        style: const TextStyle(fontSize: 24),
                        // textAlign: TextAlign.center,
                      ),
                      const Divider(
                        height: 40,
                        color: Color.fromARGB(255, 40, 122, 43),
                        thickness: 1.2,
                        // indent: 20,
                        // endIndent: 20,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Members: ',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      GroupMembersList(
                          groupId: widget.groupId!,
                          creatorUsername: widget.creatorUsername!),
                    ],
                  ),
                  const Divider(
                    height: 40,
                    color: Color.fromARGB(255, 40, 122, 43),
                    thickness: 1.2,
                    // indent: 20,
                    // endIndent: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Invite friends',
                          style: const TextStyle(fontSize: 18)),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.emoji_people_rounded,
                              size: 30,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delete member',
                          style: const TextStyle(fontSize: 18)),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.group_remove_rounded,
                              size: 30,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delete group',
                          style: const TextStyle(fontSize: 18)),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_forever_rounded,
                              size: 30,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
