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
  });
  final String? groupId;
  final String? groupName;
  final String? creatorUsername;
  final String? privacyType;
  final int? groupMembers;

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
              // decoration: BoxDecoration(color: Color.fromARGB(255, 100, 167, 74)),
              width: 260,
              // height: 450,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Container(
                    // height: 80,
                    // width: 260,
                    // decoration:
                    //     BoxDecoration(color: Color.fromARGB(192, 57, 129, 29)),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       '${widget.groupName} ( ${widget.groupMembers} ',
                        //       style: const TextStyle(fontSize: 26),
                        //     ),
                        //     const Icon(Icons.person, size: 28),
                        //     Text(
                        //       ' )',
                        //       style: const TextStyle(fontSize: 26),
                        //     ),
                        //   ],
                        // ),
                        // const
                        Text(
                          '${widget.groupName} ',
                          style: const TextStyle(fontSize: 26),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Mistrzostwa Europy - kwalifikacje',
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 40,
                    color: Color.fromARGB(255, 40, 122, 43),
                    thickness: 1.5,
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
                          'Uczestnicy: ',
                          style: TextStyle(fontSize: 18),
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
                    'Zaproś znajomych ',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Zmień nazwę grupy',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Usuń użytkownika',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Usuń grupę',
                    style: TextStyle(fontSize: 16),
                  ),

                  /// user ///
                  // const Text(
                  //   'Opuść grupę',
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
