import 'package:bet_app/src/screens/group_tabs.dart';
import 'package:bet_app/src/services/groups.dart';
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
            return const Center(
              child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                // Divider(
                //   height: 80,
                //   color: Color.fromARGB(255, 40, 122, 43),
                //   thickness: 1.5,
                //   indent: 20,
                //   endIndent: 20,
                // ),
                Text(
                  'You are not a member of any group.',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            );
          } else {
            List<Map<String, dynamic>> userGroups = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Your groups:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  // height: MediaQuery.of(context).size.height - 200,
                  height: 400,
                  width: 300,
                  child: ListView.builder(
                    // scrollDirection: Axis.horizontal,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: Color.fromARGB(255, 90, 90, 90),
                            //   width: 1,
                            // ),
                            // color: Color.fromARGB(255, 43, 43, 43),
                            color: Color.fromARGB(255, 2, 143, 65),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$groupName',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    // const SizedBox(height: 2),
                                    Text('Members: $groupMembers', style: TextStyle(fontSize: 16)),
                                  ]),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.login_rounded,
                                size: 26,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
