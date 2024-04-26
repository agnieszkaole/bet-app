import 'dart:async';
import 'package:bet_app/main.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/screens/user_groups.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/group_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  // final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Color.fromARGB(255, 26, 26, 26),
          title: const Text('Join a group'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  // constraints: BoxConstraints(maxWidth: kIsWeb ? 700.0 : MediaQuery.of(context).size.width),

                  color: Colors.transparent,
                  child: TabBar(
                    padding: EdgeInsets.only(bottom: 20),
                    indicatorColor: Color.fromARGB(255, 30, 117, 33),
                    indicatorWeight: 1.2,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    dividerColor: Color.fromARGB(38, 255, 255, 255),
                    tabs: [
                      Tab(
                        height: 60,
                        iconMargin: EdgeInsets.zero,
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.lock_open_outlined, size: 25),
                            Text(
                              '🔓',
                              style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Public',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Join without code',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Tab(
                        height: 60,
                        iconMargin: EdgeInsets.zero,
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.lock_rounded, size: 25),
                            Text(
                              '🔐',
                              style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Private',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Access code require',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          // constraints: BoxConstraints(maxWidth: kIsWeb ? 700.0 : MediaQuery.of(context).size.width),

          child: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              JoinExistingGroupScreen(privacyType: 'public'),
              JoinExistingGroupScreen(privacyType: 'private'),
            ],
          ),
        ),
      ),
    );
  }
}

class JoinExistingGroupScreen extends StatefulWidget {
  const JoinExistingGroupScreen({super.key, this.privacyType});

  final String? privacyType;

  @override
  State<JoinExistingGroupScreen> createState() => _JoinExistingGroupScreenState();
}

class _JoinExistingGroupScreenState extends State<JoinExistingGroupScreen> {
  final Groups groups = Groups();
  final TextEditingController _controllerAccessCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String? accessCodeError;
  StreamController<List<Map<String, dynamic>>> groupStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  @override
  void initState() {
    super.initState();
    groupStreamController.add([]);
    _searchController.addListener(() {
      updateFilteredGroups(_searchController.text);
    });
  }

  @override
  void dispose() {
    groupStreamController.close();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchFilteredGroups(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('groups')
        .where('groupName', isGreaterThanOrEqualTo: searchText)
        .where('groupName', isLessThanOrEqualTo: '${searchText}\uf8ff')
        .get();

    List<Map<String, dynamic>> groups = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['groupId'] = doc.id;
      return data;
    }).toList();

    return groups;
  }

  Future<void> updateFilteredGroups(String searchText) async {
    List<Map<String, dynamic>> filteredGroups = await fetchFilteredGroups(searchText);
    // print('Filtered Groups: $filteredGroups');
    await Future.delayed(const Duration(milliseconds: 300));
    filteredGroups = filteredGroups.where((group) => group['privacyType'] == widget.privacyType).toList();
    setState(() {
      groupStreamController.add(filteredGroups);
    });
  }

  Future<String?> joinToExistingGroup(
      String? groupId, String? groupName, String? privacyType, BuildContext context) async {
    try {
      await groups.joinGroup(groupId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You have joined the group: $groupName'),
      ));

      Navigator.of(context).pop(true);
      return groupId;
    } catch (e) {
      print('Error joining group: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          // height: 50,
          padding: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: Color.fromARGB(159, 32, 32, 32),
            // color: Color.fromARGB(255, 46, 46, 46),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Color.fromARGB(255, 204, 204, 204),
              width: 0.2,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search group',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: _searchController,
                  onChanged: (text) {
                    updateFilteredGroups(text);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        _searchController.text.isNotEmpty
            ? Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: groupStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'Unable to get data',
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Group not found.',
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    } else {
                      List<Map<String, dynamic>> groupsFiltered = snapshot.data!;
                      final searchedText = _searchController.text;
                      groupsFiltered = groupsFiltered.where((group) {
                        String groupName = group['groupName'];

                        return groupName.contains(searchedText);
                      }).toList();

                      return ListView.builder(
                          itemCount: groupsFiltered.length,
                          itemBuilder: (context, index) {
                            final groupData = groupsFiltered[index];
                            String? groupName = groupData['groupName'] ?? '';
                            String? groupId = groupData['groupId'];
                            String? creatorUsername = groupData['creatorUsername'];
                            String? selectedLeague = groupData['selectedLeague']['leagueName'];

                            int? groupMembers = (groupData['members'] as List<dynamic>?)?.length ?? 0;

                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                    margin: const EdgeInsets.only(bottom: 18),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.2,
                                          color: Color.fromARGB(255, 26, 112, 0),
                                        ),
                                        top: BorderSide(
                                          width: 1.2,
                                          color: Color.fromARGB(255, 26, 112, 0),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    width: 320,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 46, 46, 46)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 180,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$groupName',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 60, 165, 83),
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              Text(
                                                'League: $selectedLeague',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    // fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                              // Text(
                                              //   'Admin: $creatorUsername',
                                              //   style: const TextStyle(fontSize: 14),
                                              // ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Members: $groupMembers',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // const SizedBox(width: 30),
                                        widget.privacyType == 'public'
                                            ? Container(
                                                // width: 20,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (groupId != null) {
                                                      await joinToExistingGroup(
                                                          groupId, groupName, widget.privacyType, context);
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.person_add_alt_1_rounded,
                                                    size: 30,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 20,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    // if (groupId != null) {
                                                    //   await joinToExistingGroup(
                                                    //       groupId,
                                                    //       groupName,
                                                    //       privacyType,
                                                    //       context);
                                                    // }
                                                  },
                                                  child: const Icon(
                                                    Icons.key_outlined,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  },
                ),
              )
            : Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _firestore.collection('groups').snapshots().map((querySnapshot) {
                    // return querySnapshot.docs.map((doc) => doc.data()).toList();
                    return querySnapshot.docs.map((doc) {
                      Map<String, dynamic> data = doc.data();
                      data['groupId'] = doc.id;
                      return data;
                    }).toList();
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No groups added.',
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    } else {
                      List<Map<String, dynamic>> groups = snapshot.data!;

                      List<Map<String, dynamic>> filteredGroups =
                          groups.where((group) => group['privacyType'] == widget.privacyType).toList();

                      return ListView.builder(
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, index) {
                          final groupData = filteredGroups[index];
                          String? groupName = groupData['groupName'] ?? '';
                          String? groupId = groupData['groupId'] ?? '';
                          String? groupAccessCode = groupData['groupAccessCode'];
                          String? selectedLeague = groupData['selectedLeague']['leagueName'];
                          int? groupMembers = (groupData['members'] as List<dynamic>?)?.length ?? 0;
                          String? creatorUsername = groupData['creatorUsername'];

                          return Container(
                            constraints: BoxConstraints(maxWidth: 400),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                                  margin: const EdgeInsets.only(bottom: 18),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1.2,
                                        color: Color.fromARGB(255, 26, 112, 0),
                                      ),
                                      top: BorderSide(
                                        width: 1.2,
                                        color: Color.fromARGB(255, 26, 112, 0),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  width: 320,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 220,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('$groupName',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 60, 165, 83))),
                                            Text(
                                              'League: $selectedLeague',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            // Text(
                                            //   'Admin: $creatorUsername',
                                            //   style: const TextStyle(fontSize: 14),
                                            // ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Members: $groupMembers',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(width: 30),
                                      widget.privacyType == 'public'
                                          ? Container(
                                              width: 50,
                                              height: 50,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  if (groupId != null) {
                                                    await joinToExistingGroup(
                                                        groupId, groupName, widget.privacyType, context);
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.person_add_alt_1_rounded,
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 50,
                                              height: 50,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    accessCodeError = null;
                                                  });

                                                  _controllerAccessCode.clear();

                                                  if (groupId != null) {
                                                    showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Enter access code:',
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                          // content: Text("Enter new username"),
                                                          actions: [
                                                            Form(
                                                              key: _formKey,
                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                              child: Column(
                                                                children: [
                                                                  TextFormField(
                                                                    controller: _controllerAccessCode,
                                                                    autofocus: false,
                                                                    style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 20,
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                        errorStyle: const TextStyle(
                                                                            color: Colors.red, fontSize: 14.0),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(25)),
                                                                        contentPadding: EdgeInsets.all(10.0),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(25),
                                                                          borderSide: const BorderSide(
                                                                              color: Color.fromARGB(255, 40, 122, 43)),
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(25),
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.greenAccent),
                                                                        ),
                                                                        errorBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(25),
                                                                          borderSide: const BorderSide(
                                                                              color: Color.fromARGB(255, 255, 52, 37)),
                                                                        ),
                                                                        errorText: accessCodeError),

                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Please enter a access code';
                                                                      }

                                                                      return null;
                                                                    },
                                                                    // onSaved: (value) async {
                                                                    //   // newUsername = value;
                                                                    // },
                                                                  ),
                                                                  const SizedBox(height: 30),
                                                                  ElevatedButton(
                                                                    onPressed: () async {
                                                                      if (_formKey.currentState!.validate()) {
                                                                        if (_controllerAccessCode.text ==
                                                                            groupAccessCode) {
                                                                          await joinToExistingGroup(groupId, groupName,
                                                                              widget.privacyType, context);

                                                                          Navigator.of(context)
                                                                              .push(MaterialPageRoute(
                                                                            builder: (context) => HomeScreen(),
                                                                          ))
                                                                              .then((value) {
                                                                            if (value != null && value == true) {
                                                                              setState(() {});
                                                                            }
                                                                          });
                                                                          _controllerAccessCode.clear();
                                                                        } else {
                                                                          print('fdhgdfghd');
                                                                          setState(() {
                                                                            accessCodeError = 'Incorrect access code';
                                                                          });
                                                                        }
                                                                      }
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      foregroundColor: Colors.white,
                                                                      backgroundColor: Color.fromARGB(255, 44, 107, 15),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(25),
                                                                      ),
                                                                      // elevation: 4.0,
                                                                    ),
                                                                    child: Text('Confirm'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.key_outlined,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                // const Divider(
                                //   height: 10,
                                //   color: Color.fromARGB(255, 40, 122, 43),
                                //   thickness: 1,
                                //   // indent: 20,
                                //   // endIndent: 20,
                                // ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
        SizedBox(height: 20),
      ],
    );
  }
}
