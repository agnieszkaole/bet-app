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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider(
                  //   height: 40,
                  //   color: Color.fromARGB(255, 40, 122, 43),
                  //   thickness: 1,
                  //   indent: 20,
                  //   endIndent: 20,
                  // ),
                  Text(
                    'Your groups',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      // border: Border.all(color: Color.fromARGB(255, 53, 53, 53), width: 1),
                      image: const DecorationImage(
                        image: AssetImage("./assets/images/artificial-turf-1711556_19201.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'You are not a member of any group yet.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 10),
                Container(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                          padding: const EdgeInsets.all(8),
                          width: userGroups.length > 1 ? 180 : MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            // border: Border.all(color: Color.fromARGB(255, 53, 53, 53), width: 1),
                            image: const DecorationImage(
                              image: AssetImage("./assets/images/artificial-turf-1711556_19201.jpg"),
                              fit: BoxFit.cover,
                            ),
                            // gradient: const LinearGradient(
                            //   begin: Alignment.topRight,
                            //   end: Alignment.bottomLeft,
                            //   colors: [
                            //     Color.fromARGB(255, 75, 75, 75),
                            //     Color.fromARGB(255, 37, 37, 37),
                            //   ],
                            // color: Color.fromARGB(255, 39, 39, 39),
                          ),
                          constraints: BoxConstraints(maxWidth: 400),
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        const SizedBox(height: 3),
                                        Text(
                                          'Members: $groupMembers',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 6),
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
