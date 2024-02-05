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
            Container(
              width: 260,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Group name',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${widget.groupName} ',
                          style: const TextStyle(fontSize: 26),
                        ),
                        const Divider(
                          height: 40,
                          color: Color.fromARGB(255, 40, 122, 43),
                          thickness: 1.2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Text(
                          'Selected league',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${widget.selectedLeagueName}',
                          style: const TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 40,
                    color: Color.fromARGB(255, 40, 122, 43),
                    thickness: 1.2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    // height: 180,
                    width: 260,
                    // decoration: BoxDecoration(
                    //     color: const Color.fromARGB(221, 129, 129, 129)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const SizedBox(height: 10),
                        Text(
                          'Members: ',
                          style: TextStyle(fontSize: 20),
                        ),

                        GroupMembersList(
                            groupId: widget.groupId!,
                            creatorUsername: widget.creatorUsername!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// admin ///
                  Text(
                    'Invite friends',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Change group name',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Delete member',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Delete group',
                    style: TextStyle(fontSize: 16),
                  ),

                  /// user ///
                  // const Text(
                  //   'Leave the group',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
