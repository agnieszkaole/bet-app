import "package:bet_app/widgets/predicted_list.dart";
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
      appBar: AppBar(
        title: const Text('Grupy'),
      ),
      body: Center(
        child: Text(
          'Utwórz grupę',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
