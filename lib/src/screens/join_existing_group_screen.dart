import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/group_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinExistingGroupScreen extends StatefulWidget {
  const JoinExistingGroupScreen({super.key});

  @override
  State<JoinExistingGroupScreen> createState() =>
      _JoinExistingGroupScreenState();
}

class _JoinExistingGroupScreenState extends State<JoinExistingGroupScreen> {
  Groups groups = Groups();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // String? groupId;
  // String? groupName;

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<String?> joinToExistingGroup(
  //     String? groupId, BuildContext context) async {
  //   try {
  //     await groups.joinGroup(groupId);
  //     Navigator.of(context).pop();
  //     return groupId;
  //   } catch (e) {
  //     print('Error joining group: $e');
  //     rethrow;
  //   }
  // }

  Future<String?> joinToExistingGroup(
      String? groupId, String? groupName, BuildContext context) async {
    try {
      await groups.joinGroup(groupId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dołączyłeś do grupy $groupName'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dołącz do grupy'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Brak dostępnych grup.',
                style: TextStyle(fontSize: 22),
              ),
            );
          } else {
            List<Map<String, dynamic>> groups = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              String? groupId = doc.id;
              data['groupId'] = groupId;
              return data;
            }).toList();

            return Center(
              child: SizedBox(
                width: 300,
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final groupData = groups[index];
                    String? groupName = groupData['name'] ?? '';
                    String? groupId = groupData['groupId'];
                    int groupMembers =
                        (groupData['members'] as List<dynamic>?)?.length ?? 0;

                    return GestureDetector(
                      onTap: () {
                        if (groupId != null) {
                          joinToExistingGroup(groupId, groupName, context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        // height: 80,
                        width: 100,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(10),
                        //   border: Border.all(
                        //     color: Color.fromARGB(255, 90, 90, 90),
                        //     width: 1,
                        //   ),
                        // color: const Color.fromARGB(255, 56, 56, 56)
                        // decoration: BoxDecoration(color: Colors.blue),
                        // ),
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
                                  const SizedBox(width: 30),
                                  const Icon(Icons.person_add_alt_1_rounded,
                                      size: 30),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 20,
                              color: Color.fromARGB(158, 76, 175, 79),
                              thickness: 1,
                              // indent: 20,
                              // endIndent: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
