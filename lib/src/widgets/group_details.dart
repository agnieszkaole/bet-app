import 'package:bet_app/src/screens/group_tabs.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/group_members_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  String? groupPrivacyType;

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
        groupPrivacyType = result['privacyType'];
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

  deleteMemberFromFirebase() async {
    await groups.deleteMemberFromGroup(widget.groupId, currentUser);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('You left group: ${widget.groupName}'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // print('${widget.groupRules}');
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            // height: 500,
            width: MediaQuery.of(context).size.width - 50, constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              color: Color.fromARGB(118, 51, 51, 51),
              border: Border.all(
                width: .8,
                color: Color.fromARGB(192, 22, 124, 36),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Group name',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 39, 190, 72),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.groupName}  ',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                            // textAlign: TextAlign.left,
                          ),
                          Text(
                            '${widget.privacyType == "private" ? " 🔐" : " 🔓"}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 22),
                            // textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected league',
                        style: const TextStyle(
                          fontSize: 18,
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
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  // width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Creation date',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 60, 165, 83),
                        ),
                      ),
                      Column(
                        children: [
                          widget.createdAt != null
                              ? Text(widget.createdAt!, style: const TextStyle(fontSize: 18))
                              : Text(' ', style: const TextStyle(fontSize: 18))
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 15),
                Container(
                  width: 220,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Members (${widget.groupMembers})',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 60, 165, 83),
                        ),
                      ),
                      GroupMembersList(groupId: widget.groupId!, creatorUsername: widget.creatorUsername!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(height: 15),
          widget.creatorUsername != currentUser
              ? Container(
                  width: MediaQuery.of(context).size.width - 50,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(150, 62, 155, 19),
                          Color.fromARGB(150, 31, 77, 10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color.fromARGB(255, 102, 102, 102), width: 0.4)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Leave', style: const TextStyle(fontSize: 18)),
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
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Color.fromARGB(255, 255, 1, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                side: BorderSide(color: Color.fromARGB(255, 255, 1, 1)),
                                              ),
                                              // elevation: 4.0,
                                            ),
                                            onPressed: () async {
                                              await deleteMemberFromFirebase();
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => HomeScreen(),
                                              ))
                                                  .then((value) {
                                                if (value != null && value == true) {
                                                  setState(() {});
                                                }
                                              });
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Color.fromARGB(255, 2, 126, 6),
                                                foregroundColor: Color.fromARGB(255, 255, 255, 255)),
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
                                        ]);
                                  });
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.person_remove_alt_1_rounded,
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
                )
              : Container(
                  width: MediaQuery.of(context).size.width - 50,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(150, 62, 155, 19),
                          Color.fromARGB(150, 31, 77, 10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color.fromARGB(255, 102, 102, 102), width: 0.4)),
                  child: Column(
                    children: [
                      widget.privacyType == 'private'
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Access code', style: const TextStyle(fontSize: 18)),
                                    Text('${groupAccessCode}', style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            )
                          : SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Invite friends', style: const TextStyle(fontSize: 18)),
                          GestureDetector(
                            onTap: () {
                              widget.privacyType == 'private'
                                  ? Share.share(
                                      'Are you ready to bet with your friends? Download GreatBet and join a private group: "${widget.groupName}" - access code: ${groupAccessCode} or other public group. GreatBet Team',
                                    )
                                  : Share.share(
                                      'Are you ready to bet with your friends? Download GreatBet and join a public group: "${widget.groupName}" or create a private group. GreatBet Team');
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
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Color.fromARGB(255, 255, 1, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                side: BorderSide(color: Color.fromARGB(255, 255, 1, 1)),
                                              ),
                                              // elevation: 4.0,
                                            ),
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
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Color.fromARGB(255, 2, 126, 6),
                                                foregroundColor: Color.fromARGB(255, 255, 255, 255)),
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
                  ),
                )
        ],
      ),
    );
  }
}
