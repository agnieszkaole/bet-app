import 'package:bet_app/src/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? user = Auth().currentUser;
  String? username;

  Future<String?> getUsernameFromFirebase() async {
    try {
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          String username = userData['username'] ?? '';
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

    return '';
  }
}
