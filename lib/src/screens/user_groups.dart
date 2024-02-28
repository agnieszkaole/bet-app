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
                Divider(
                  height: 40,
                  color: Color.fromARGB(255, 40, 122, 43),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  'Your groups:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Container(
                  // height: 300,
                  // width: 300,
                  constraints: BoxConstraints(maxWidth: 400), margin: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromARGB(255, 90, 90, 90),
                      width: 1,
                    ),
                    // color: Color.fromARGB(255, 39, 39, 39),
                    // color: Color.fromARGB(255, 2, 143, 65),
                    // gradient: const LinearGradient(
                    //   begin: Alignment.topRight,
                    //   end: Alignment.bottomLeft,
                    //   colors: [
                    //     Color.fromARGB(255, 10, 110, 224),
                    //     Color.fromARGB(255, 4, 70, 146),
                    //   ],
                    // ),
                  ),
                  child: Text(
                    'You are not a member of any group.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          } else {
            List<Map<String, dynamic>> userGroups = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your groups:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Container(
                  // height: MediaQuery.of(context).size.height - 20,
                  height: 400,
                  // width: 320,
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color: Color.fromARGB(255, 90, 90, 90),
                    //   width: 1,
                    // ),
                    // color: Color.fromARGB(255, 36, 36, 36),
                    // color: Color.fromARGB(255, 2, 143, 65),
                    // gradient: const LinearGradient(
                    //   begin: Alignment.topRight,
                    //   end: Alignment.bottomLeft,
                    //   colors: [
                    //     Color.fromARGB(255, 29, 114, 58),
                    //     Color.fromARGB(255, 6, 82, 35),
                    //   ],
                    // ),
                  ),
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
                          constraints: BoxConstraints(maxWidth: 400),
                          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 0, 92, 41),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // width: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$groupName',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 60, 165, 83)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // const SizedBox(height: 2),
                                      Text('Members: $groupMembers', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  const Icon(
                                    Icons.login_rounded,
                                    size: 26,
                                  ),
                                ],
                              ),
                              // const Divider(
                              //   height: 30,
                              //   color: Color.fromARGB(255, 40, 122, 43),
                              //   thickness: 1,
                              // ),
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
