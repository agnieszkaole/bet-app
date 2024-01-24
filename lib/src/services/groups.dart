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

  Future<List<Map<String, dynamic>>> getGroups() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('groups').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting groups: $e');
      return [];
    }
  }

  Future<void> addUserToGroup(
      String groupId, String groupName, String userEmail) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userSnapshot.exists) {
          List<dynamic> userGroups = userSnapshot['groups'] ?? [];

          if (!userGroups.any((group) => group['groupId'] == groupId)) {
            await _firestore.collection('users').doc(currentUser.uid).update({
              'groups': FieldValue.arrayUnion([
                {'groupId': groupId, 'groupName': groupName},
              ]),
            });
            await _firestore.collection('groups').doc(groupId).update(
              {
                'memberEmail': userEmail,
              },
            );
            print('User added to the group successfully!');
          } else {
            print('User is already a member of the group');
          }
        } else {
          print('User document not found');
        }
      }
    } catch (e) {
      print('Error adding user to group: $e');
    }
  }
}
