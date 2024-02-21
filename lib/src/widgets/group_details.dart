import 'package:bet_app/src/screens/group_tabs.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/group_members_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class GroupDetails extends StatefulWidget {
  const GroupDetails({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupMembers,
    required this.creatorUsername,
    required this.privacyType,
    required this.createdAt,
    this.selectedLeagueName,
  });
  final String? groupId;
  final String? groupName;
  final String? creatorUsername;
  final String? privacyType;
  final int? groupMembers;
  final Timestamp? createdAt;
  final String? selectedLeagueName;

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  String? newGroupName;
  Groups groups = Groups();
  String? uniqueIdKey;
  late DateTime createdAtDate;
  String? formattedCreatedAtDate;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUser;

  @override
  void initState() {
    super.initState();
    getAccessCodeToGroup();
    _formatDate();
    _getCurrentUserDisplayName();
  }

  void _formatDate() {
    createdAtDate = widget.createdAt!.toDate();
    formattedCreatedAtDate = DateFormat('yyyy-MM-dd').format(createdAtDate);
  }

  Future<void> getAccessCodeToGroup() async {
    try {
      Map<String, dynamic>? result = await groups.getDataAboutGroup(widget.groupId!);

      setState(() {
        uniqueIdKey = result['uniqueIdKey'];
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _getCurrentUserDisplayName() {
    User? user = _auth.currentUser;
    if (user != null) {
      currentUser = user.displayName;
    }
  }

  void deleteGroupFromFirebase() async {
    await groups.deleteGroup(widget.groupId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Group deleted successfully'),
    ));
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void deleteMemberFromFirebase() async {
    await groups.deleteMemberFromGroup(widget.groupId, currentUser);
    print(widget.groupId);
    print(currentUser);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('You left this group'),
    ));
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => HomeScreen()),
    // );
  }

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
                                style: const TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
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
                        style: const TextStyle(fontSize: 22),
                        // textAlign: TextAlign.center,
                      ),
                      const Divider(
                        height: 40,
                        color: Color.fromARGB(255, 40, 122, 43),
                        thickness: 1.2,
                        // indent: 20,
                        // endIndent: 20,
                      ),
                      const Text(
                        'Creation date',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$formattedCreatedAtDate',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
                        ],
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
                      GroupMembersList(groupId: widget.groupId!, creatorUsername: widget.creatorUsername!),
                    ],
                  ),
                  const Divider(
                    height: 40,
                    color: Color.fromARGB(255, 40, 122, 43),
                    thickness: 1.2,
                    // indent: 20,
                    // endIndent: 20,
                  ),
                  widget.creatorUsername != currentUser
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Leave group', style: const TextStyle(fontSize: 18)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text('Delete group'),
                                              content: Text('Are you sure you want to leave this group? '),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteMemberFromFirebase();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ]);
                                        });
                                  },
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
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Invite friends', style: const TextStyle(fontSize: 18)),
                                GestureDetector(
                                  onTap: () {
                                    Share.share(
                                      'Are you ready to bet with your friends? Download Betapp and join a private group: "${widget.groupName}" - access code: ${uniqueIdKey} or other public group. Betapp Team',
                                    );
                                  },
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
                                Text('Delete group', style: const TextStyle(fontSize: 18)),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text('Delete group'),
                                              content: Text(
                                                  'Are you sure you want to delete this group? Once deleted it cannot be recovered.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteGroupFromFirebase();
                                                  },
                                                  child: const Text(
                                                    'Yes, delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ]);
                                        });
                                  },
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
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
