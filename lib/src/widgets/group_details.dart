import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';

class GroupDetails extends StatefulWidget {
  const GroupDetails({
    super.key,
    required this.groupId,
    required this.groupName,
  });
  final String? groupId;
  final String? groupName;

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  Groups groups = Groups();

  Future<String?> joinToExistingGroup(
      String? groupId, BuildContext context) async {
    try {
      await groups.joinGroup(groupId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dołączyłeś do grupy ${widget.groupName}'),
        ),
      );
      Navigator.of(context).pop();
      return groupId;
    } catch (e) {
      print('Error joining group: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('${widget.groupName}'),
          Container(
              key: Key(widget.groupId ?? ''),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          const Text('Dołącz'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (widget.groupId != null) {
                                joinToExistingGroup(widget.groupId, context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
