import 'package:bet_app/src/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? user = Auth().currentUser;
  // String? username;

  Future<String?> getUserDataFromFirebase() async {
    try {
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          String? username = userData['username'] ?? '';
          List<dynamic>? groups = userData['groups'];

          if (groups != null) {
            groups.forEach((group) {
              print('${group["groupName"]} ,${group['groupId']} ');
            });
          }

          return username;
        } else {
          print('User data not found in Firestore');
        }
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('$e');
    }

    return null;
  }

  Future<List<Map<String, dynamic>>?> getMatchesResultsForUser(String userUid, int leagueNumber) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('predictions')
          .where('leagueNumber', isEqualTo: leagueNumber)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> matchesData = [];

        for (var documentSnapshot in userQuerySnapshot.docs) {
          matchesData.add(documentSnapshot.data());
        }
        // print(matchesData);
        return matchesData;
      }
    } catch (e) {
      print('Error fetching matches results for user: $e');
    }

    return null;
  }

  // Future<List<Map<String, dynamic>>?> getMatchesResultsFromFirebase(int leagueNumber) async {
  //   try {
  //     if (user != null) {
  //       // QuerySnapshot<Map<String, dynamic>> userQuerySnapshot = await FirebaseFirestore.instance
  //       //     .collection('users')
  //       //     .doc(user!.uid)
  //       //     .collection('matches')
  //       //     .where('leagueNumber', isEqualTo: leagueNumber)
  //       //     .get();

  //       QuerySnapshot<Map<String, dynamic>> userQuerySnapshot = await FirebaseFirestore.instance
  //           .collectionGroup('predictions')
  //           .where('leagueNumber', isEqualTo: leagueNumber)
  //           .get();

  //       if (userQuerySnapshot.docs.isNotEmpty) {
  //         List<Map<String, dynamic>> matchesData = [];

  //         for (var documentSnapshot in userQuerySnapshot.docs) {
  //           matchesData.add(documentSnapshot.data());
  //         }
  //         // print(matchesData);
  //         return matchesData;
  //       }
  //     } else {
  //       print('User is not authenticated');
  //     }
  //   } catch (e) {
  //     print('$e');
  //   }

  //   return null;
  // }

  Future<String?> getInfoAboutUserGroups() async {
    try {
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          String? username = userData['username'] ?? '';

          return username;
        } else {
          print('User data not found in Firestore');
        }
      } else {
        print('User is not authenticated');
      }
    } catch (e) {
      print('$e');
    }

    return null;
  }

  Future<void> updateDisplayName(String newDisplayName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newDisplayName);
        print('Display name updated successfully to: $newDisplayName');
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Failed to update display name: $e');
    }
  }

  Future<void> updateUsernameField(String userId, String newUsername) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({'username': newUsername});
      print('Username field updated successfully to: $newUsername');
    } catch (e) {
      print('Failed to update username field: $e');
    }
  }

  Future<bool> isDisplayNameAvailable(String displayName) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: displayName).get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking display name availability: $e');

      return false;
    }
  }

  Future<bool> isUsernameNameAvailable(String newUsername) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: newUsername).get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      // Handle any errors
      print('Error checking username availability: $e');
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent successfully');
    } catch (e) {
      print('Failed to send password reset email: $e');
    }
  }

  Future<void> deleteUserAndData(String userId, email, password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var credential = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
        await FirebaseFirestore.instance.collection('users').doc(userId).delete();
        await FirebaseFirestore.instance.collection('groups').get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });

        await user.delete();

        print('User authentication account and data deleted successfully');
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Failed to delete user and data: $e');
    }
  }
}
