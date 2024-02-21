import 'dart:async';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class SelectCriteriaScreen extends StatefulWidget {
  const SelectCriteriaScreen({
    super.key,
  });

  @override
  State<SelectCriteriaScreen> createState() => _SelectCriteriaScreenState();
}

class _SelectCriteriaScreenState extends State<SelectCriteriaScreen> {
  // String? selectedLeagueNumber;
  // String? selectedLeagueName;
  User? user = Auth().currentUser;
  bool? isAnonymous = true;
  bool? isUsernameModify = false;
  String? username;

  @override
  void initState() {
    super.initState();
    initUserDetails();
    // selectedLeagueNumber = '106';
  }

  Future<void> initUserDetails() async {
    User? user = Auth().currentUser;
    if (user != null) {
      isAnonymous = user.isAnonymous;
    }
    String? initialUsername = await UserData().getUsernameFromFirebase();

    setState(() {
      username = initialUsername;
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        UserData().getUsernameFromFirebase().then((newUsername) {
          setState(() {
            username = newUsername;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // late List<SoccerMatch> nextMatchesList = context.watch<NextMatchesProvider>().nextMatchesList;
    // final ScrollController _scrollController = ScrollController();
    // print(selectedLeagueNumber);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${username != null ? '$username' : ''}',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Let\'s start betting with your friends. 🖐',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Upcoming matches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 200,
              child: NextMatchList(),
            ),
            const SizedBox(height: 10),
            const Text(
              'Predictions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // StandingsList(),
            // SizedBox(
            //   // width: 200,
            //   child: Card(
            //       elevation: 5,
            //       child: Container(
            //         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            //         decoration: BoxDecoration(
            //           // color: Color.fromARGB(255, 53, 53, 53),
            //           borderRadius: BorderRadius.circular(8),
            //           border: Border.all(width: 0.5),
            //           gradient: const LinearGradient(
            //             begin: Alignment.topRight,
            //             end: Alignment.bottomLeft,
            //             colors: [
            //               Color.fromARGB(146, 0, 199, 90),
            //               Color.fromARGB(108, 0, 92, 41),
            //             ],
            //           ),
            //         ),
            //         child: Column(
            //           children: [
            //             SizedBox(height: 10),
            //             Text(
            //               '9.02.2024  20:00',
            //               style: const TextStyle(),
            //             ),
            //             Text(
            //               'Puchar Polski',
            //               style: const TextStyle(),
            //             ),
            //             Container(
            //               // width: 150,
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       CachedNetworkImage(
            //                         imageUrl: 'homeLogo',
            //                         fadeInDuration: const Duration(milliseconds: 50),
            //                         placeholder: (context, url) => const CircularProgressIndicator(),
            //                         errorWidget: (context, url, error) => const Icon(Icons.error),
            //                         width: 36.0,
            //                         height: 36.0,
            //                       ),
            //                       Text(
            //                         'Lech Poznań',
            //                         textAlign: TextAlign.center,
            //                         style: const TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 14.0,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   Text(
            //                     "vs",
            //                     textAlign: TextAlign.center,
            //                     style: TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 16.0,
            //                     ),
            //                   ),
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       CachedNetworkImage(
            //                         imageUrl: 'homeLogo',
            //                         fadeInDuration: const Duration(milliseconds: 50),
            //                         placeholder: (context, url) => const CircularProgressIndicator(),
            //                         errorWidget: (context, url, error) => const Icon(Icons.error),
            //                         width: 36.0,
            //                         height: 36.0,
            //                       ),
            //                       Text(
            //                         'Piast Gliwice',
            //                         style: const TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 14.0,
            //                         ),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                     ],
            //                   )
            //                 ],
            //               ),
            //             )
            //           ],
            //         ),
            //       )),
            // ),

            SizedBox(width: 10),
          ]),
        ),
      ),
    );
  }
}
