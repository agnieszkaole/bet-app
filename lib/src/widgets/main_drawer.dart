import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/ranking_screen.dart';
import 'package:bet_app/src/screens/user_account.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 40, 122, 43)),
            child: Row(
              children: [
                // const SizedBox(
                //   width: 18,
                // ),
                Text(
                  'Bet',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_box,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text('Twój profil'),
            onTap: () {
              Navigator.of(context).pop();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => UserAccountScreen(),
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
            title: Text('Ustawienia'),
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
