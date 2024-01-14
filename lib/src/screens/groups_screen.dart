// import 'package:bet_app/src/widgets/main_drawer.dart';
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
        child: Expanded(
          child: Column(
            children: [
              const SizedBox(height: 50),
              SvgPicture.asset(
                'assets/images/undraw_selecting_team_re_ndkb.svg',
                width: 250,
              ),
              const SizedBox(height: 30),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                  ),
                  child: const Text(
                    "Utwórz nową grupę",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    // shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 2.0,
                      color: const Color.fromARGB(255, 40, 122, 43),
                    ),
                  ),
                  child: const Text(
                    "Dołącz do istniejącej grupy",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
