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
  final String? createdAt;
  final String? selectedLeagueName;

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  String? newGroupName;
  Groups groups = Groups();
  String? groupAccessCode;
  String? groupRules;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUser;
  String? privacyType;

  @override
  void initState() {
    super.initState();

    // _formatDate();
    _getGroupData();
    _getCurrentUserDisplayName();
  }

  Future<void> _getGroupData() async {
    try {
      Map<String, dynamic>? result = await groups.getDataAboutGroup(widget.groupId!);
      setState(() {
        groupAccessCode = result['groupAccessCode'];
        groupRules = result['groupRules'];
        print(groupRules);
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
    // print('${widget.groupRules}');
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            // width: 300,
            child: Column(
              children: [
                Column(
                  children: [
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Text(
                              'Group name',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 60, 165, 83),
                              ),
                            ),
                            Text(
                              '${widget.groupName}',
                              // overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 20),
                              // textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Text(
                              'Group rules',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 60, 165, 83),
                              ),
                            ),
                            Container(
                              width: 280,
                              height: 100,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    groupRules == null
                                        ? Text(
                                            'No rules given ',
                                            style: const TextStyle(fontSize: 20),
                                          )
                                        : Text(
                                            '${groupRules} ',
                                            style: const TextStyle(fontSize: 18),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              'Selected league',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 60, 165, 83),
                              ),
                            ),
                            SizedBox(height: 3),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                '${widget.selectedLeagueName}',
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Text(
                              'Creation date',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 60, 165, 83),
                              ),
                            ),
                            Column(
                              children: [
                                widget.createdAt != null
                                    ? Text(widget.createdAt!, style: const TextStyle(fontSize: 20))
                                    : Text(' ', style: const TextStyle(fontSize: 20))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        // height: 160,
                        child: Column(
                          children: [
                            Text(
                              'Members (${widget.groupMembers})',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 60, 165, 83),
                              ),
                            ),
                            GroupMembersList(groupId: widget.groupId!, creatorUsername: widget.creatorUsername!),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                                  privacyType == 'private'
                                      ? Share.share(
                                          'Are you ready to bet with your friends? Download Betapp and join a private group: "${widget.groupName}" - access code: ${groupAccessCode} or other public group. Betapp Team',
                                        )
                                      : Share.share(
                                          'Are you ready to bet with your friends? Download Betapp and join a public group: "${widget.groupName}" or create a private group. Betapp Team');
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
    );
  }
}
