import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';

class JoinExistingGroupScreen extends StatefulWidget {
  const JoinExistingGroupScreen({super.key});

  @override
  State<JoinExistingGroupScreen> createState() =>
      _JoinExistingGroupScreenState();
}

class _JoinExistingGroupScreenState extends State<JoinExistingGroupScreen> {
  Groups groups = Groups();
  List<Map<String, dynamic>> existingGroups = [];

  Future<List<Map<String, dynamic>>> getExistingGroup() async {
    return await groups.getGroups();
  }

  Future<void> joinGroup(
    String groupId,
    String groupName,
    String userEmail,
  ) async {
    try {
      await groups.addUserToGroup(groupId, groupName, userEmail);
    } catch (e) {
      print('Error joining group: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Istniejące grupy'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getExistingGroup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Brak dostęnych grup.',
                    style: TextStyle(fontSize: 22)));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final groupData = snapshot.data![index];
                final groupName = groupData['name'] ?? '';
                final groupId = groupData['id'] ?? '';

                return ListTile(
                  title: Text(groupName ?? ''),
                  leading: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      joinGroup(groupId, groupName, 'jerzy@wp.pl');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
