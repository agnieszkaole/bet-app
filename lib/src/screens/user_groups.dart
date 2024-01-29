import 'package:bet_app/src/services/groups.dart';

import 'package:flutter/material.dart';

class UserGroups extends StatelessWidget {
  const UserGroups({super.key});

  @override
  Widget build(BuildContext context) {
    Groups groups = Groups();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: groups.getUserGroupsWithMembers(),
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
                      // String? groupId = groupData['groupId'];
                      int groupMembers = groupData['numberOfUsers'];

                      return GestureDetector(
                        onTap: () {
                          print(groupName);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          height: 50,
                          width: 230,
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
                                    const Icon(Icons.login_rounded),
                                  ],
                                ),
                              ),
                              // const Divider(
                              //   height: 20,
                              //   color: Color.fromARGB(158, 76, 175, 79),
                              //   thickness: 1,
                              //   // indent: 20,
                              //   // endIndent: 20,
                              // ),
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
