import 'dart:async';
import 'package:bet_app/main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/group_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select a group'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Column(
              children: [
                SizedBox(height: 15),
                TabBar(
                  padding: EdgeInsets.only(bottom: 20),
                  indicatorColor: Colors.green,
                  indicatorWeight: 2.0,
                  labelColor: Colors.white,
                  dividerColor: Color.fromARGB(38, 255, 255, 255),
                  tabs: [
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_open_outlined, size: 25),
                          SizedBox(width: 5),
                          Text('Public'),
                        ],
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_rounded, size: 25),
                          SizedBox(width: 5),
                          Text('Private'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            JoinExistingGroupScreen(privacyType: 'public'),
            JoinExistingGroupScreen(privacyType: 'private'),
          ],
        ),
      ),
    );
  }
}

class JoinExistingGroupScreen extends StatefulWidget {
  const JoinExistingGroupScreen({super.key, this.privacyType});

  final String? privacyType;

  @override
  State<JoinExistingGroupScreen> createState() =>
      _JoinExistingGroupScreenState();
}

class _JoinExistingGroupScreenState extends State<JoinExistingGroupScreen> {
  final Groups groups = Groups();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> groupStreamController =
      BehaviorSubject<List<Map<String, dynamic>>>();

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

  Future<List<Map<String, dynamic>>> fetchFilteredGroups(
      String searchText) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('groups')
        .where('name', isGreaterThanOrEqualTo: searchText.toLowerCase())
        .where('name', isLessThanOrEqualTo: '${searchText.toLowerCase()}\uf8ff')
        // .where('privacyType', isEqualTo: widget.privacyType)
        .get();

    List<Map<String, dynamic>> groups = querySnapshot.docs
        .map((doc) => doc.data()..['groupId'] = doc.id)
        .toList();
    print(groups.length);
    return groups;
  }

  Future<void> updateFilteredGroups(String searchText) async {
    List<Map<String, dynamic>> filteredGroups =
        await fetchFilteredGroups(searchText);
    // print('Filtered Groups: $filteredGroups');
    await Future.delayed(const Duration(milliseconds: 300));
    filteredGroups = filteredGroups
        .where((group) => group['privacyType'] == widget.privacyType)
        .toList();
    groupStreamController.add(filteredGroups);
  }

  Future<String?> joinToExistingGroup(String? groupId, String? groupName,
      String? privacyType, BuildContext context) async {
    try {
      await groups.joinGroup(groupId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have joined the group: $groupName'),
        ),
      );
      Navigator.of(context).pop();
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
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Search',
            controller: _searchController,
            onChanged: (text) {
              updateFilteredGroups(text);
            },
          ),
        ),
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
                          'No group added.',
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Group not found..',
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    } else {
                      List<Map<String, dynamic>> groupsFiltered =
                          snapshot.data!;

                      return ListView.builder(
                          itemCount: groupsFiltered.length,
                          itemBuilder: (context, index) {
                            final groupData = groupsFiltered[index];
                            String? groupName = groupData['name'] ?? '';
                            String? groupId = groupData['groupId'];
                            String? creatorUsername =
                                groupData['creatorUsername'];

                            int? groupMembers =
                                (groupData['members'] as List<dynamic>?)
                                        ?.length ??
                                    0;

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupDetails(
                                    groupId: groupId,
                                    groupMembers: groupMembers,
                                    groupName: groupName,
                                    creatorUsername: creatorUsername,
                                    privacyType: widget.privacyType,
                                  ),
                                ));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 300,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: SizedBox(
                                              width: 50,
                                              child: CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 40, 122, 43),
                                                child: Icon(Icons.groups),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$groupName',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Members: $groupMembers',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 30),
                                          widget.privacyType == 'public'
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    if (groupId != null) {
                                                      await joinToExistingGroup(
                                                          groupId,
                                                          groupName,
                                                          widget.privacyType,
                                                          context);
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons
                                                        .person_add_alt_1_rounded,
                                                    size: 30,
                                                  ),
                                                )
                                              : GestureDetector(
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
                                        ],
                                      ),
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
                  stream: _firestore
                      .collection('groups')
                      .snapshots()
                      .map((querySnapshot) {
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

                      List<Map<String, dynamic>> filteredGroups = groups
                          .where((group) =>
                              group['privacyType'] == widget.privacyType)
                          .toList();

                      return ListView.builder(
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, index) {
                          final groupData = filteredGroups[index];
                          String? groupName = groupData['name'] ?? '';
                          String? groupId = groupData['groupId'] ?? '';
                          String? creatorUsername =
                              groupData['creatorUsername'];

                          int? groupMembers =
                              (groupData['members'] as List<dynamic>?)
                                      ?.length ??
                                  0;

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GroupDetails(
                                  groupId: groupId,
                                  groupMembers: groupMembers,
                                  groupName: groupName,
                                  creatorUsername: creatorUsername,
                                  privacyType: widget.privacyType,
                                ),
                              ));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: 300,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: CircleAvatar(
                                            backgroundColor: Color.fromARGB(
                                                255, 40, 122, 43),
                                            child: Icon(Icons.groups),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$groupName',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Members: $groupMembers',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 30),
                                        widget.privacyType == 'public'
                                            ? GestureDetector(
                                                onTap: () async {
                                                  if (groupId != null) {
                                                    await joinToExistingGroup(
                                                        groupId,
                                                        groupName,
                                                        widget.privacyType,
                                                        context);
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons
                                                      .person_add_alt_1_rounded,
                                                  size: 30,
                                                ),
                                              )
                                            : GestureDetector(
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
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              )
      ],
    );
  }
}
