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
            return Container(
              height: 140,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your groups',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      // border: Border.all(color: Color.fromARGB(255, 53, 53, 53), width: 1),
                      image: const DecorationImage(
                        image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'You are not a member of any group yet.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            List<Map<String, dynamic>> userGroups = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your groups',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: userGroups.length,
                    itemBuilder: (context, index) {
                      final groupData = userGroups[index];
                      String? groupName = groupData['groupName'];
                      String? groupId = groupData['groupId'];
                      String? privacyType = groupData['privacyType'];

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
                              privacyType: privacyType,
                            ),
                          ));
                        },
                        child: Container(
                          // padding: const EdgeInsets.all(5),
                          width: userGroups.length > 1 ? 200 : MediaQuery.of(context).size.width - 50,

                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            border: Border.all(
                              width: .5,
                              color: Color.fromARGB(255, 151, 151, 151),
                            ),
                            image: DecorationImage(
                              image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
                              fit: BoxFit.cover,
                            ),
                            color: Color.fromARGB(255, 39, 39, 39),
                          ),
                          constraints: BoxConstraints(maxWidth: 400),
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text(
                                      '$groupName',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        // color: Color.fromARGB(255, 255, 255, 255),
                                        // color: Color.fromARGB(255, 60, 165, 83),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Members: $groupMembers',
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Icon(
                                      Icons.login_rounded,
                                      size: 26,
                                      // color: Color.fromARGB(255, 0, 151, 68),
                                    ),
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
            );
          }
        });
  }
}
