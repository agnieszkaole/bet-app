import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/group_tabs.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserGroups extends StatelessWidget {
  final List<Map<String, dynamic>> userGroups;

  UserGroups({required this.userGroups, super.key, this.onGroupCreated});
  final onGroupCreated;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userGroups.length,
        itemBuilder: (context, index) {
          final groupData = userGroups[index];
          String? groupName = groupData['groupName'];
          String? groupId = groupData['groupId'];
          String? privacyType = groupData['privacyType'];
          String? leagueName = groupData['leagueName'];
          String? creatorUsername = groupData['creatorUsername'];
          int? groupMembers = groupData['numberOfUsers'];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GroupTabs(
                  groupName: groupName,
                  groupId: groupId,
                  groupMembers: groupMembers,
                  creatorUsername: creatorUsername,
                  privacyType: privacyType,
                ),
              ));
            },
            child: Container(
              width: userGroups.length == 1 ? MediaQuery.of(context).size.width - 50 : 250,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 400),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 19, 19, 19).withOpacity(0.6),
                    offset: const Offset(5.0, 5.0),
                    blurRadius: 6.0,
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: AppColors.greenDark,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$groupName',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 180,
                        child: Text(
                          '$leagueName',
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.login_rounded,
                    size: 26,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
