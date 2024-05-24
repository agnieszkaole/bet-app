import 'package:bet_app/src/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Groups {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createGroup(
    String? groupName,
    String? privacyType,
    Map<String, dynamic>? selectedLeague,
    List<Map<String, dynamic>>? members,
    String? groupAccessCode,
  ) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Check if the group name already exists
        QuerySnapshot groupNameQuery =
            await _firestore.collection('groups').where('groupName', isEqualTo: groupName).get();

        if (groupNameQuery.docs.isNotEmpty) {
          return false; // Group name already exists
        }

        members?.add({
          'memberUid': currentUser.uid,
          'memberUsername': currentUser.displayName,
          'totalScore': 0,
        });

        Timestamp currentTime = Timestamp.now();

        DocumentReference groupReference = await _firestore.collection('groups').add({
          'groupName': groupName,
          'creatorUid': currentUser.uid,
          'creatorUsername': currentUser.displayName,
          'members': members,
          'selectedLeague': {'leagueName': selectedLeague?['name'], 'leagueNumber': selectedLeague?['number']},
          'privacyType': privacyType,
          'createdAt': currentTime,
          'groupAccessCode': groupAccessCode,
          // 'groupRules': groupRules
        });

        await _firestore.collection('users').doc(currentUser.uid).update({
          'groups': FieldValue.arrayUnion([
            {
              'groupId': groupReference.id,
              'groupName': groupName,
              'privacyType': privacyType,
              'createdAt': currentTime,
            },
          ]),
        });

        print('Group created successfully!');
        return true;
      } else {
        print('User is not authenticated');
        return false;
      }
    } catch (e) {
      print('Error creating group: $e');
      return false;
    }
  }

  Future<void> joinGroup(String? groupId) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null && groupId != null) {
        DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await _firestore.collection('groups').doc(groupId).get();

        if (groupSnapshot.exists) {
          // List<Map<String, dynamic>> members = List<Map<String, dynamic>>.from(groupSnapshot.data()?['members'] ?? []);
          var data = groupSnapshot.data();
          if (data == null) {
            print('Group data is null');
            return;
          }

          // List<dynamic> membersList = groupSnapshot.data()?['members'] ?? [];
          // List<Map<String, dynamic>> members = membersList.cast<Map<String, dynamic>>();
          List<dynamic> membersList = data['members'] ?? [];
          List<Map<String, dynamic>> members = membersList.map((member) {
            if (member is Map<String, dynamic>) {
              return member;
            } else if (member is Map) {
              return Map<String, dynamic>.from(member);
            } else {
              throw Exception('Invalid member type');
            }
          }).toList();

          // if (membersList.length >= 3) {
          //   print('Group is full, cannot join.');
          //   return;
          // }

          bool isUserAlreadyMember = members.any((member) =>
              member['memberUid'] == currentUser.uid && member['memberUsername'] == currentUser.displayName);

          if (!isUserAlreadyMember) {
            members.add({
              'memberUid': currentUser.uid,
              'memberUsername': currentUser.displayName,
            });

            await _firestore.collection('groups').doc(groupId).update({
              'members': members,
            });
            await _firestore.collection('users').doc(currentUser.uid).update({
              'groups': FieldValue.arrayUnion([
                {
                  'groupId': groupId,
                  'groupName': groupSnapshot.data()?['groupName'],
                },
              ]),
            });

            print('User joined group successfully!');
          } else {
            print('User is already a member of the group');
          }
        } else {
          print('Group does not exist');
        }
      } else {
        print('User is not authenticated or groupId is null');
      }
    } catch (e) {
      print('Error joining group: $e');
    }
  }

  // Future<Map<String, dynamic>> getDataAboutGroup(String? groupId) async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await _firestore.collection('groups').doc(groupId).get();

  //     if (groupSnapshot.exists) {
  //       int? numberOfUsers;
  //       String? creatorUsername;
  //       String? privacyType;
  //       String? groupRules;
  //       List<Map<String, dynamic>> members = [];
  //       Map<String, dynamic> selectedLeague = {};
  //       String? groupAccessCode;
  //       String? groupId;
  //       Timestamp? createdAt;

  //       if (groupSnapshot.data()?['members'] != null) {
  //         members = List<Map<String, dynamic>>.from(groupSnapshot.data()?['members']);

  //         numberOfUsers = members.length;
  //       }
  //       if (groupSnapshot.data()?['creatorUsername'] != null) {
  //         creatorUsername = groupSnapshot.data()?['creatorUsername'];
  //       }

  //       if (groupSnapshot.data()?['privacyType'] != null) {
  //         privacyType = groupSnapshot.data()?['privacyType'];
  //       }

  //       if (groupSnapshot.data()?['selectedLeague'] != null) {
  //         selectedLeague = Map<String, dynamic>.from(groupSnapshot.data()?['selectedLeague']);
  //       }

  //       if (groupSnapshot.data()?['groupAccessCode'] != null) {
  //         groupAccessCode = groupSnapshot.data()?['groupAccessCode'];
  //       }
  //       if (groupSnapshot.data()?['createdAt'] != null) {
  //         createdAt = groupSnapshot.data()?['createdAt'];
  //       }

  //       if (groupSnapshot.data()?['groupRules'] != null) {
  //         groupRules = groupSnapshot.data()?['groupRules'];
  //       }
  //       if (groupSnapshot.data()?['groupIds'] != null) {
  //         groupRules = groupSnapshot.data()?['groupId'];
  //       }

  //       return {
  //         'numberOfUsers': numberOfUsers,
  //         'creatorUsername': creatorUsername,
  //         'privacyType': privacyType,
  //         'members': members,
  //         'selectedLeague': selectedLeague,
  //         'groupAccessCode': groupAccessCode,
  //         'createdAt': createdAt,
  //         'groupRules': groupRules,
  //         'groupId': groupId,
  //         // 'selected': members,
  //       };
  //     }

  //     return {'error': 'Group not found'};
  //   } catch (e) {
  //     print('Error getting group data: $e');
  //     return {'error': 'Error getting group data'};
  //   }
  // }

  Future<Map<String, dynamic>> getDataAboutGroup(String? groupId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await _firestore.collection('groups').doc(groupId).get();

      if (groupSnapshot.exists) {
        int? numberOfUsers;
        String? creatorUsername;
        String? privacyType;
        String? groupRules;
        List<Map<String, dynamic>> members = [];
        Map<String, dynamic> selectedLeague = {};
        String? groupAccessCode;
        Timestamp? createdAt;

        var data = groupSnapshot.data();

        if (data != null) {
          members = List<Map<String, dynamic>>.from(data['members'] as List);

          numberOfUsers = members.length;

          creatorUsername = data['creatorUsername'];
          privacyType = data['privacyType'];
          selectedLeague = Map<String, dynamic>.from(data['selectedLeague'] ?? {});
          groupAccessCode = data['groupAccessCode'];
          createdAt = data['createdAt'];
          groupRules = data['groupRules'];
        }

        return {
          'numberOfUsers': numberOfUsers,
          'creatorUsername': creatorUsername,
          'privacyType': privacyType,
          'members': members,
          'selectedLeague': selectedLeague,
          'groupAccessCode': groupAccessCode,
          'createdAt': createdAt,
          'groupRules': groupRules,
          'groupId': groupId,
        };
      }

      return {'error': 'Group not found'};
    } catch (e) {
      print('Error getting group data: $e');
      return {'error': 'Error getting group data'};
    }
  }

  Future<List<Map<String, dynamic>>> getUserGroupsData() async {
    List<Map<String, dynamic>> userGroups = [];

    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userSnapshot.exists) {
          userGroups = List<Map<String, dynamic>>.from(userSnapshot.data()?['groups'] ?? []);

          // Use Future.forEach to await async operations within the loop
          await Future.forEach(userGroups, (group) async {
            String? groupId = group['groupId'];
            Map<String, dynamic> groupData = await getDataAboutGroup(groupId ?? '');

            int? numberOfUsers = groupData['numberOfUsers'];
            String? creatorUsername = groupData['creatorUsername'];

            group['numberOfUsers'] = numberOfUsers ?? 0;
            group['creatorUsername'] = creatorUsername;
          });
        }
      }
      return userGroups;
    } catch (e) {
      print('Error getting user groups: $e');
      return userGroups;
    }
  }

  Future<bool> isGroupNameAvailable(String newGroupName) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').where('name', isEqualTo: newGroupName).get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      // Handle any errors
      print('Error checking group name availability: $e');
      return false;
    }
  }

  Future<void> deleteGroup(String? groupIdDelete) async {
    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      await FirebaseFirestore.instance.collection('groups').doc(groupIdDelete).delete();
      for (QueryDocumentSnapshot<Map<String, dynamic>> userSnapshot in usersSnapshot.docs) {
        if (userSnapshot.data().containsKey('groups') && userSnapshot.data()['groups'] != null) {
          List<dynamic> userGroups = List<dynamic>.from(userSnapshot.data()['groups']);
          bool containsGroupId = userGroups.any((map) => map.containsValue(groupIdDelete));

          userGroups.removeWhere((map) => map.containsValue(groupIdDelete));
          await FirebaseFirestore.instance.collection('users').doc(userSnapshot.id).update({'groups': userGroups});
          print('User ${userSnapshot.id} updated successfully');
          // }
        }
      }
      print('Group and references removed successfully');
    } catch (e) {
      print('Error removing group and references: $e');
    }
  }

  Future<Map<String, dynamic>> deleteMemberFromGroup(String? groupId, String? member) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await _firestore.collection('groups').doc(groupId).get();
      if (!groupSnapshot.exists) {
        return {'error': 'Group not found'};
      }

      List<Map<String, dynamic>> members = [];
      if (groupSnapshot.data()?['members'] != null) {
        members = List<Map<String, dynamic>>.from(groupSnapshot.data()?['members']);
        if (members.isEmpty) {
          return {'error': 'Member list is empty'};
        }
      } else {
        return {'error': 'Member list is empty'};
      }

      // Remove the member from the group's members list
      members.removeWhere((element) => element['memberUsername'] == member);
      await _firestore.collection('groups').doc(groupId).update({'members': members});
      User? user = Auth().currentUser;

      DocumentReference userDocRef = _firestore.collection('users').doc(user?.uid);
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await userDocRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (userSnapshot.exists) {
        List<Map<String, dynamic>> userGroups = List<Map<String, dynamic>>.from(userSnapshot.data()?['groups'] ?? []);
        userGroups.removeWhere((group) => group['groupId'] == groupId);
        await userDocRef.update({'groups': userGroups});
      }

      // Return success message
      return {'success': 'Member successfully removed from the group'};
    } catch (e) {
      print('Error deleting member from group: $e');
      return {'error': 'Error deleting member from group'};
    }
  }
}
