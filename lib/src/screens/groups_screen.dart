// import 'package:bet_app/src/widgets/main_drawer.dart';
import 'package:bet_app/src/screens/new_group_screen.dart';
import 'package:bet_app/src/screens/join_existing_group_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // SvgPicture.asset(
            //   'assets/images/undraw_team_re_0bfe.svg',
            //   width: 250,
            // ),
            Image.asset(
              'assets/images/image-from-rawpixel-id-6651280-original.png',
              width: 280,
            ),
            const SizedBox(height: 15),
            const Text(
              "Stwórz swoją grupę i zaproś znajomych lub dołącza do istniejącej.    ",
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NewGroupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // shape: const StadiumBorder(),
                    // minimumSize: const Size(280, 50),
                    backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Utwórz nową grupę",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const JoinExistingGroupScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  // shape: const StadiumBorder(),
                  // minimumSize: const Size(300, 50),
                  side: const BorderSide(
                    width: 1.5,
                    color: Color.fromARGB(255, 40, 122, 43),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dołącz do instniejącej grupy",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Icon(
                      Icons.group_add_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
