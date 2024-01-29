import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Groups {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createGroup(
      String? groupName, List<Map<String, dynamic>>? members) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        members?.add(
          {'memberUid': currentUser.uid, 'memberEmail': currentUser.email},
        );

        DocumentReference groupReference =
            await _firestore.collection('groups').add({
          'name': groupName,
          'creatorUid': currentUser.uid,
          'creatorEmail': currentUser.email,
          'members': members
        });

        await _firestore.collection('users').doc(currentUser.uid).update({
          'groups': FieldValue.arrayUnion([
            {
              'groupId': groupReference.id,
              'groupName': groupName,
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
              member['memberEmail'] == currentUser.email);

          if (!isUserAlreadyMember) {
            // Add the current user as a member
            members.add({
              'memberUid': currentUser.uid,
              'memberEmail': currentUser.email,
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

  Future<int> getNumberOfUsersInGroup(String groupId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> groupSnapshot =
          await _firestore.collection('groups').doc(groupId).get();

      if (groupSnapshot.exists) {
        // Check if the 'members' field exists in the group data
        if (groupSnapshot.data()?['members'] != null) {
          List<Map<String, dynamic>> members =
              List<Map<String, dynamic>>.from(groupSnapshot.data()?['members']);

          // Return the number of users in the group
          return members.length;
        }
      }

      // If the group or 'members' field doesn't exist, return 0
      return 0;
    } catch (e) {
      print('Error getting number of users in group: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getUserGroupsWithMembers() async {
    List<Map<String, dynamic>> userGroups = [];

    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userSnapshot.exists) {
          userGroups = List<Map<String, dynamic>>.from(
              userSnapshot.data()?['groups'] ?? []);

          // Add the number of users in each group to the userGroups list
          for (var group in userGroups) {
            String? groupId = group['groupId'];
            int numberOfUsers = await getNumberOfUsersInGroup(groupId ?? '');
            group['numberOfUsers'] = numberOfUsers;
          }
        }
      }
      return userGroups;
    } catch (e) {
      print('Error getting user groups: $e');
      return userGroups;
    }
  }
}
