import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Groups {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createGroup(
      String? groupName,
      String? privacyType,
      Map<String, dynamic>? selectedLeague,
      List<Map<String, dynamic>>? members) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        members?.add({
          'memberUid': currentUser.uid,
          'memberUsername': currentUser.displayName,
        });

        DocumentReference groupReference =
            await _firestore.collection('groups').add({
          'name': groupName,
          'creatorUid': currentUser.uid,
          'creatorUsername': currentUser.displayName,
          'members': members,
          'selectedLeague': {
            'leagueName': selectedLeague?['name'],
            'leagueNumber': selectedLeague?['number']
          },
          'privacyType': privacyType,
        });

        await _firestore.collection('users').doc(currentUser.uid).update({
          'groups': FieldValue.arrayUnion([
            {
              'groupId': groupReference.id,
              'groupName': groupName,
              'privacyType': privacyType,
            },
          ]),
        });

        print('Group created successfully!');
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('Error creating group: $e');
    }
  }

  Future<void> joinGroup(String? groupId) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null && groupId != null) {
        // Retrieve the group document
        DocumentSnapshot<Map<String, dynamic>> groupSnapshot =
            await _firestore.collection('groups').doc(groupId).get();

        if (groupSnapshot.exists) {
          // Get the current members of the group
          List<Map<String, dynamic>> members = List<Map<String, dynamic>>.from(
              groupSnapshot.data()?['members'] ?? []);

          // Check if the user is already a member
          bool isUserAlreadyMember = members.any((member) =>
              member['memberUid'] == currentUser.uid &&
              member['memberUsername'] == currentUser.displayName);

          if (!isUserAlreadyMember) {
            // Add the current user as a member
            members.add({
              'memberUid': currentUser.uid,
              'memberUsername': currentUser.displayName,
            });

            // Update the group document with the new member
            await _firestore.collection('groups').doc(groupId).update({
              'members': members,
            });

            // Update the user document with the joined group
            await _firestore.collection('users').doc(currentUser.uid).update({
              'groups': FieldValue.arrayUnion([
                {
                  'groupId': groupId,
                  'groupName': groupSnapshot.data()?['name'],
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

  // Future<List<Map<String, dynamic>>> getUserGroups() async {
  //   List<Map<String, dynamic>> userGroups = [];

  //   try {
  //     User? currentUser = _auth.currentUser;

  //     if (currentUser != null) {
  //       DocumentSnapshot<Map<String, dynamic>> userSnapshot =
  //           await _firestore.collection('users').doc(currentUser.uid).get();

  //       if (userSnapshot.exists) {
  //         userGroups = List<Map<String, dynamic>>.from(
  //             userSnapshot.data()?['groups'] ?? []);
  //       }
  //     }
  //     return userGroups;
  //   } catch (e) {
  //     print('Error getting user groups: $e');
  //     return userGroups;
  //   }
  // }
  Future<Map<String, dynamic>> getDataAboutGroup(String groupId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> groupSnapshot =
          await _firestore.collection('groups').doc(groupId).get();

      if (groupSnapshot.exists) {
        int? numberOfUsers;
        String? creatorUsername;
        String? privacyType;
        List<Map<String, dynamic>> members = [];
        Map<String, dynamic> selectedLeague = {};

        if (groupSnapshot.data()?['members'] != null) {
          members =
              List<Map<String, dynamic>>.from(groupSnapshot.data()?['members']);

          numberOfUsers = members.length;
        }
        if (groupSnapshot.data()?['creatorUsername'] != null) {
          creatorUsername = groupSnapshot.data()?['creatorUsername'];
        }

        if (groupSnapshot.data()?['privacyType'] != null) {
          privacyType = groupSnapshot.data()?['privacyType'];
        }

        if (groupSnapshot.data()?['selectedLeague'] != null) {
          selectedLeague = Map<String, dynamic>.from(
              groupSnapshot.data()?['selectedLeague']);
        }

        return {
          'numberOfUsers': numberOfUsers,
          'creatorUsername': creatorUsername,
          'privacyType': privacyType,
          'members': members,
          'selectedLeague': selectedLeague,
          // 'selected': members,
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
          userGroups = List<Map<String, dynamic>>.from(
              userSnapshot.data()?['groups'] ?? []);

          await Future.wait(userGroups.map((group) async {
            String? groupId = group['groupId'];
            Map<String, dynamic> groupData =
                await getDataAboutGroup(groupId ?? '');

            int? numberOfUsers = groupData['numberOfUsers'];
            String? creatorUsername = groupData['creatorUsername'];

            group['numberOfUsers'] = numberOfUsers ?? 0;
            group['creatorUsername'] = creatorUsername;
          }));
        }
      }
      return userGroups;
    } catch (e) {
      print('Error getting user groups: $e');
      return userGroups;
    }
  }
}
