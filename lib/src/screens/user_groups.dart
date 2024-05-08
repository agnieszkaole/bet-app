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
              constraints: const BoxConstraints(maxWidth: 400),
              width: MediaQuery.of(context).size.width - 60,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Your groups',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      // border: Border.all(color: Color.fromARGB(255, 53, 53, 53), width: 1),
                      image: DecorationImage(
                        image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
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
            // print(userGroups);
            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '⭐️   ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Your groups',
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      '   ⭐️',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const Text(
                  'Choose one of your groups and start betting.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Container(
                  height: 150,
                  constraints: const BoxConstraints(maxWidth: 400),
                  width: MediaQuery.of(context).size.width - 60,
                  padding: const EdgeInsets.all(15),

                  //  image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
                  decoration: const BoxDecoration(
                    // image: const DecorationImage(
                    //   image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
                    //   fit: BoxFit.cover,
                    // ),
                    color: Color.fromARGB(200, 39, 39, 39),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
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
                          print('$creatorUsername');
                        },
                        child: Container(
                          // padding: const EdgeInsets.all(5),
                          width: userGroups.length > 1 ? 200 : MediaQuery.of(context).size.width - 50,

                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 19, 19, 19).withOpacity(0.6),
                                offset: const Offset(5.0, 5.0),
                                blurRadius: 6.0,
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            // border: Border.all(
                            //   width: .5,
                            //   color: const Color.fromARGB(255, 151, 151, 151),
                            // ),
                            // image: const DecorationImage(
                            //   image: AssetImage("./assets/images/lawn-5007569_19201.jpg"),
                            //   fit: BoxFit.cover,
                            // ),
                            color: const Color.fromARGB(211, 58, 139, 21),
                          ),
                          constraints: const BoxConstraints(maxWidth: 400),
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      style: const TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.login_rounded,
                                  size: 26,
                                  // color: Color.fromARGB(255, 0, 151, 68),
                                ),
                              ],
                            ),
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
