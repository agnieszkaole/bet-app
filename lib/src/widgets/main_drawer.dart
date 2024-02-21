import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/ranking_screen.dart';
import 'package:bet_app/src/screens/user_profile.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: const DrawerHeader(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 155, 64)),
              child: Row(
                children: [
                  Text(
                    'Betapp',
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
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => UserProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text('Settings'),
            onTap: () async {
              Navigator.of(context).pop();

              // await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (ctx) => const GroupsScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
