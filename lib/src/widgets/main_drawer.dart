import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';

import 'package:bet_app/src/screens/user_profile.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Future<void> signOut() async {
    await Auth().signOutUserAccount();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Auth().currentUser;
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('./assets/images/little-1506570_19201.png'),
            //   fit: BoxFit.cover,
            // ),
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 29, 29, 29),
            Color.fromARGB(255, 49, 49, 49),
          ],
        )),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 62, 155, 19),
                      Color.fromARGB(255, 31, 77, 10),
                    ],
                  ),
                  // border: Border.all(color: Color.fromARGB(255, 2, 47, 64), width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      'GreatBet',
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_box,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const UserProfileScreen(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.settings,
            //     size: 26,
            //     color: Theme.of(context).colorScheme.onBackground,
            //   ),
            //   title: Text('Settings'),
            //   onTap: () async {
            //     Navigator.of(context).pop();

            //     // await Navigator.of(context).push(
            //     //   MaterialPageRoute(
            //     //     builder: (ctx) => const GroupsScreen(),
            //     //   ),
            //     // );
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.stars_rounded,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: const Text('Upgrade'),
              onTap: () async {},
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: const Text('Logout'),
              onTap: () async {
                signOut();
                print('User is logged out: ${user!.uid}');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
