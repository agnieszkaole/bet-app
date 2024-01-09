import 'package:bet_app/src/widgets/main_drawer.dart';
import "package:flutter/material.dart";

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Utwórz nową grupę'),
        //   actions: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.add),
        //       iconSize: 30,
        //     ),
        //   ],
        // ),
        drawer: MainDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Zapisane grupy',
                style: TextStyle(fontSize: 20),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '..........',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '..........',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }
}
