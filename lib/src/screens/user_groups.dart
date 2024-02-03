import 'package:bet_app/src/screens/group_tab.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/group_details.dart';

import 'package:flutter/material.dart';

class UserGroups extends StatefulWidget {
  const UserGroups({super.key});

  @override
  State<UserGroups> createState() => _UserGroupsState();
}

class _UserGroupsState extends State<UserGroups> {
  @override
  Widget build(BuildContext context) {
    Groups groups = Groups();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: groups.getUserGroupsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: 30, height: 30, child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Column(
            children: [
              Divider(
                height: 80,
                color: Color.fromARGB(255, 40, 122, 43),
                thickness: 1.5,
                indent: 20,
                endIndent: 20,
              ),
              Text(
                'Nie jesteś zapisany do żadnej grupy',
                style: TextStyle(fontSize: 18),
              ),
            ],
          );
        } else {
          List<Map<String, dynamic>> userGroups = snapshot.data!;
          return Container(
            constraints: const BoxConstraints(maxWidth: 350),
            // width: 320,
            // decoration: BoxDecoration(color: Colors.blue),
            // width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 80,
                  color: Color.fromARGB(255, 40, 122, 43),
                  thickness: 1.5,
                  // indent: 20,
                  // endIndent: 20,
                ),
                Text(
                  'Grupy, do których należysz:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: userGroups.length,
                    itemBuilder: (context, index) {
                      final groupData = userGroups[index];
                      String? groupName = groupData['groupName'];
                      String? groupId = groupData['groupId'];
                      String? creatorUsername = groupData['creatorUsername'];
                      int? groupMembers = groupData['numberOfUsers'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GroupTabs(
                              groupName: groupName,
                              groupId: groupId,
                              groupMembers: groupMembers,
                              creatorUsername: creatorUsername,
                            ),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          height: 50,
                          width: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color.fromARGB(255, 90, 90, 90),
                              width: 1,
                            ),
                            // color: const Color.fromARGB(255, 56, 56, 56)
                            // decoration: BoxDecoration(color: Colors.blue),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: CircleAvatar(
                                        // backgroundImage: AssetImage(
                                        //   'assets/images/image-from-rawpixel-id-6626581-original.png',
                                        // ),
                                        child: Icon(Icons.groups),

                                        backgroundColor:
                                            Color.fromARGB(255, 40, 122, 43),
                                      ),
                                    ),
                                    Column(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('$groupName',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Text('Uczestnicy: $groupMembers',
                                              style: TextStyle(fontSize: 16)),
                                        ]),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.login_rounded),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
