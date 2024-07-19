import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/group_members_list.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Group deleted successfully'),
    ));
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
          const SizedBox(height: 20),
          Container(
            width: 250,
            // width: MediaQuery.of(context).size.width - 40,
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                Container(
                  // height: 250,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  decoration: const BoxDecoration(
                    // border: Border.all(
                    //   width: 0.8,
                    //   color: const Color.fromARGB(170, 62, 155, 19),
                    // ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: Color.fromARGB(57, 80, 80, 80),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Group name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 130),
                            child: Text(
                              '${widget.groupName}  ',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15),
                              // textAlign: TextAlign.left,
                            ),
                          ),
                          Text(
                            '${widget.privacyType == "private" ? " 🔐" : " 🔓"}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18),
                            // textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Selected league',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          '${widget.selectedLeagueName}',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          const Text(
                            'Creation date',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.green,
                            ),
                          ),
                          Column(
                            children: [
                              widget.createdAt != null
                                  ? Text(widget.createdAt!, style: const TextStyle(fontSize: 15))
                                  : const Text(' ', style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  // height: 230,
                  width: 250,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  decoration: const BoxDecoration(
                    // border: Border.all(
                    //   width: 0.8,
                    //   color: const Color.fromARGB(170, 62, 155, 19),
                    // ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: Color.fromARGB(57, 80, 80, 80),
                  ),

                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Members (${widget.groupMembers})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                      GroupMembersList(groupId: widget.groupId!, creatorUsername: widget.creatorUsername!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
                color: AppColors.greenDark,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.greenDark, width: 0.6)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Check rules', style: TextStyle(fontSize: 18)),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: const Color.fromARGB(221, 0, 3, 31),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: FractionallySizedBox(
                                  heightFactor: 0.9,
                                  child: SingleChildScrollView(
                                    child: Stack(children: [
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          onTap: () => Navigator.pop(context),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Betting rules',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 0.5,
                                                color: const Color.fromARGB(170, 62, 155, 19),
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: Image.asset(
                                                    './assets/images/football-157931_1280.png',
                                                    width: 30,
                                                  ),
                                                  title: const SizedBox(
                                                    child: Text(
                                                      'To start betting enter your group.',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Image.asset(
                                                    './assets/images/football-157931_1280.png',
                                                    width: 30,
                                                  ),
                                                  title: const SizedBox(
                                                    child: Text(
                                                      'The time for betting ends when the match starts.',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Image.asset(
                                                    './assets/images/football-157931_1280.png',
                                                    width: 30,
                                                  ),
                                                  title: const SizedBox(
                                                    child: Text(
                                                      'The bet can only be edited until the match starts. It can be done in "Bets" tab.',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Image.asset(
                                                    './assets/images/football-157931_1280.png',
                                                    width: 30,
                                                  ),
                                                  title: const SizedBox(
                                                    child: Text(
                                                      'Your bets will be visible in the "Bets table" only after the match starts. Until then the question mark ("?") is displayed.',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Scoring rules',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 0.5,
                                                color: const Color.fromARGB(170, 62, 155, 19),
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: Container(
                                                    width: 55,
                                                    padding: const EdgeInsets.all(5),
                                                    // color: Color.fromARGB(104, 112, 112, 112),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: const Color.fromARGB(192, 22, 124, 36),
                                                    ),
                                                    child: const Text(
                                                      '3 pts',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        shadows: [
                                                          Shadow(
                                                            offset: Offset(1.0, 1.0),
                                                            blurRadius: 1.0,
                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  title: const SizedBox(
                                                    child: Text(
                                                      'Exact result',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  subtitle: const Text('Correctly predicted the exact result.'),
                                                ),
                                                ListTile(
                                                  leading: Container(
                                                    width: 55,
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: const Color.fromARGB(230, 175, 172, 9),
                                                    ),
                                                    child: const Text(
                                                      '1 pt',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        shadows: [
                                                          Shadow(
                                                            offset: Offset(1, 1),
                                                            blurRadius: 1.0,
                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  title: const Text(
                                                    'Trend of result',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  subtitle: const Text(
                                                      'Correctly predicted the trend of result (win, draw, lose).'),
                                                ),
                                                ListTile(
                                                  // leading: Image.asset(
                                                  //   './assets/images/football-157931_1280.png',
                                                  //   width: 30,
                                                  // ),
                                                  leading: Container(
                                                    width: 55,
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: const Color.fromARGB(120, 241, 0, 0),
                                                    ),
                                                    child: const Text(
                                                      '0 pt',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        shadows: [
                                                          Shadow(
                                                            offset: Offset(1.0, 1.0),
                                                            blurRadius: 1.0,
                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  title: const Text(
                                                    'Wrong result',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                  subtitle: const Text('Inorrectly predicted the result.'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.new_releases,
                            size: 25,
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
          const SizedBox(height: 20),
          widget.creatorUsername != currentUser
              ? Container(
                  width: MediaQuery.of(context).size.width - 50,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 1, 129, 24),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.greenDark, width: 0.6)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Leave group', style: TextStyle(fontSize: 18)),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierColor: const Color.fromARGB(167, 9, 11, 29),
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            side: BorderSide(color: AppColors.green),
                                            borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                        title: const Text('Leave group'),
                                        content: const Text('Are you sure you want to leave this group? '),
                                        actions: [
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: const Color.fromARGB(255, 255, 1, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                side:
                                                    const BorderSide(width: 0.8, color: Color.fromARGB(255, 255, 1, 1)),
                                              ),
                                              // elevation: 4.0,
                                            ),
                                            onPressed: () async {
                                              await deleteMemberFromFirebase();
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => const HomeScreen(),
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
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: AppColors.greenDark,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                side: const BorderSide(width: 1, color: AppColors.greenDark),
                                              ),
                                              // elevation: 4.0,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                color: AppColors.green,
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
                                  size: 25,
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                      border: Border.all(color: const Color.fromARGB(255, 102, 102, 102), width: 0.4)),
                  child: Column(
                    children: [
                      widget.privacyType == 'private'
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Access code', style: TextStyle(fontSize: 18)),
                                    Text('${groupAccessCode}', style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            )
                          : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Invite friends', style: TextStyle(fontSize: 18)),
                          GestureDetector(
                            onTap: () {
                              widget.privacyType == 'private'
                                  ? Share.share(
                                      'Are you ready to bet with your friends? Download BetSprint and join a private group: "${widget.groupName}" - access code: ${groupAccessCode} or other public group. BetSprint Team',
                                    )
                                  : Share.share(
                                      'Are you ready to bet with your friends? Download BetSprint and join a public group: "${widget.groupName}" or create a private group. BetSprint Team');
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delete group', style: TextStyle(fontSize: 18)),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierColor: const Color.fromARGB(167, 9, 11, 29),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            side: BorderSide(color: AppColors.green),
                                            borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                        title: const Text('Delete group'),
                                        content: const Text(
                                            'Are you sure you want to delete this group? Once deleted it cannot be recovered.'),
                                        actions: [
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: const Color.fromARGB(255, 255, 1, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                side: const BorderSide(color: Color.fromARGB(255, 255, 1, 1)),
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
                                                backgroundColor: const Color.fromARGB(255, 2, 126, 6),
                                                foregroundColor: const Color.fromARGB(255, 255, 255, 255)),
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
