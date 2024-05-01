import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardGroup extends StatefulWidget {
  const LeaderboardGroup({super.key});

  @override
  State<LeaderboardGroup> createState() => _LeaderboardGroupState();
}

class _LeaderboardGroupState extends State<LeaderboardGroup> {
  String? selectedGroupId;
  String? groupName;

  Future<void> fetchGroupData(String selectedGroupId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('groups').doc(selectedGroupId).get();

      if (snapshot.exists) {
        setState(() {
          groupName = snapshot.data()?['groupName'];
        });
      } else {
        setState(() {
          groupName = '';
        });
        print('Document does not exist for ID: $selectedGroupId');
      }
    } catch (e) {
      setState(() {
        groupName = '';
      });
      print('Error fetching document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('groups').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
            List<String> documentIds = documents.map((doc) => doc.id).toList();
            List groupNames = documents.map((doc) => doc.data()['groupName'] ?? '').toList();

            return Container(
              height: 80,
              width: 350,
              margin: EdgeInsets.only(top: 25),
              child: InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 31, 77, 10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.greenAccent),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 10,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 35,
                        color: Color.fromARGB(255, 158, 158, 158),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedGroupId,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: Text(
                        'Select a group',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedGroupId = newValue;
                          });
                          fetchGroupData(newValue);
                        }
                      },
                      icon: SizedBox.shrink(),
                      items: documentIds.map((documentId) {
                        int index = documentIds.indexOf(documentId);
                        String groupName = groupNames[index];
                        return DropdownMenuItem<String>(
                          value: documentId,
                          child: SizedBox(
                            width: 300,
                            child: Center(
                              child: Text(
                                groupName,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 500,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('groups').doc(selectedGroupId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for data, show a loading indicator
                  return Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  // If an error occurs, display the error message
                  final error = snapshot.error;
                  return Center(
                    child: Text(
                      '$error',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final members = snapshot.data!.data()?['members'] as List<dynamic>?;

                  if (members != null && members.isNotEmpty) {
                    members.sort((a, b) {
                      final int scoreA = a['score'] ?? 0;
                      final int scoreB = b['score'] ?? 0;
                      return scoreB.compareTo(scoreA);
                    });

                    return Container(
                      width: 350,
                      child: ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index] as Map<String, dynamic>;
                          final memberUsername = member['memberUsername'] as String?;
                          final score = member['score'] as int?;

                          final rankingOrder = index + 1;

                          String imageAsset = "";
                          Color backgroundColor = Colors.transparent;
                          Color gradient1 = Colors.transparent;
                          Color gradient2 = Colors.transparent;

                          Color textColor = const Color.fromARGB(255, 255, 255, 255);
                          TextStyle usernameTextStyle = TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          );

                          if (rankingOrder == 1) {
                            imageAsset = './assets/images/trophy-153395_1280.png';

                            backgroundColor = const Color.fromARGB(255, 235, 177, 5);
                            gradient1 = Color.fromARGB(255, 255, 204, 0);
                            gradient2 = Color.fromARGB(255, 212, 175, 55);
                            textColor = const Color.fromARGB(255, 255, 255, 255);
                            usernameTextStyle = TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            );
                          } else if (rankingOrder == 2) {
                            imageAsset = './assets/images/cup-2015198_1280.png';
                            backgroundColor = Color.fromARGB(255, 122, 122, 122);
                            gradient1 = Color.fromARGB(255, 97, 98, 99);
                            gradient2 = Color.fromARGB(255, 185, 185, 185);
                            textColor = const Color.fromARGB(255, 255, 255, 255);
                            usernameTextStyle = TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            );
                          } else if (rankingOrder == 3) {
                            imageAsset = './assets/images/football-157931_1280.png';
                            backgroundColor = Color.fromARGB(255, 126, 75, 0);
                            gradient1 = Color.fromARGB(255, 151, 101, 21);
                            gradient2 = Color.fromARGB(255, 184, 134, 11);
                            textColor = const Color.fromARGB(255, 255, 255, 255);
                            usernameTextStyle = TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            );
                          }

                          return rankingOrder < 4
                              ? Container(
                                  height: 50,
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(78, 59, 59, 59),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      width: 0.6,
                                      color: Color.fromARGB(255, 148, 148, 148),
                                    ),
                                    // gradient: LinearGradient(
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    //   colors: [gradient1, gradient2],
                                    // ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [gradient1, gradient2],
                                                ),
                                                borderRadius: BorderRadius.circular(25),
                                                border: Border.all(
                                                  width: 0.6,
                                                  color: Color.fromARGB(255, 148, 148, 148),
                                                ),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '$rankingOrder.  ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: textColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '$memberUsername',
                                              style: usernameTextStyle,
                                            ),
                                            SizedBox(width: 15),
                                            if (rankingOrder == 1)
                                              Image.asset(
                                                imageAsset,
                                                height: 35,
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        ' ${score ?? '0'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(78, 59, 59, 59),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      width: 0.6,
                                      color: Color.fromARGB(255, 148, 148, 148),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [gradient1, gradient2],
                                                ),
                                                // borderRadius: BorderRadius.circular(25),
                                                // border: Border.all(
                                                //   width: 0.6,
                                                //   color: Color.fromARGB(255, 148, 148, 148),
                                                // ),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text('$rankingOrder.  ',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: textColor,
                                                    ),
                                                    textAlign: TextAlign.center),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '$memberUsername',
                                              style: usernameTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${score ?? '0'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            './assets/images/cup-2015198_1280.png',
                            width: 250,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Select a group to see leaderboard',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  }
                }

                // If snapshot does not have data, return a loading indicator or placeholder
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        )
      ]),
    );
  }
}
