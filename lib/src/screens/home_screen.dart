import 'package:bet_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/groups_screen.dart';
import 'package:bet_app/src/screens/leaderboard_screen.dart';
import 'package:bet_app/src/screens/select_criteria_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:bet_app/src/services/user_data.dart';
import 'package:bet_app/src/widgets/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = Auth().currentUser;
  bool isAnonymous = true;
  String? username = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    initUserDetails();
  }

  Future<void> _fetchUserData() async {
    User? user = Auth().currentUser;
    if (user != null) {
      setState(() {
        isAnonymous = user.isAnonymous;
        // username = firebaseUsername ?? '';
      });
    } else {
      print('No user is currently logged in');
    }
  }

  Future<void> initUserDetails() async {
    setState(() {
      User? user = Auth().currentUser;
      if (user != null) {
        isAnonymous = user.isAnonymous;
      }
    });
    username = await UserData().getUserDataFromFirebase();
    setState(() {});
  }

  void showLoginScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  Future<void> signOut() async {
    await Auth().signOutUserAccount();
    print('User is logged out: ${user!.uid}');

    showLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              // constraints: BoxConstraints(maxWidth: kIsWeb ? 700.0 : MediaQuery.of(context).size.width),
              child: AppBar(
                actions: [
                  // PopupMenuButton(
                  // constraints: const BoxConstraints.expand(width: 140, height: 60),
                  // offset: const Offset(0, 60),
                  // elevation: 50,
                  // icon: isAnonymous
                  //     ? Icon(
                  //         Icons.account_circle,
                  //         size: 45,
                  //         color: Color.fromARGB(255, 163, 163, 163),
                  //       )
                  //     : Icon(
                  //         Icons.account_circle,
                  //         size: 45,
                  //         color: Color.fromARGB(255, 0, 155, 64),
                  //       ),
                  // initialValue: selectedMenu,
                  // onSelected: (SampleItem item) {
                  //   setState(() {
                  //     selectedMenu = item;
                  //   });
                  // },
                  // itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  // PopupMenuItem(
                  // value: 1,
                  // child: isAnonymous
                  // ? GestureDetector(
                  //     onTap: () {
                  //       Navigator.of(context)
                  //           .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
                  //     },
                  //     child: Container(
                  //       child: const Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Padding(
                  //             padding: EdgeInsets.symmetric(horizontal: 10),
                  //             child: Text(
                  //               'Login',
                  //               style: TextStyle(
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ),
                  //           Icon(
                  //             Icons.login,
                  //             // color: Color.fromARGB(255, 40, 122, 43),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   )
                  //           : GestureDetector(
                  //               onTap: () {
                  //                 signOut();
                  //               },
                  //               child: Container(
                  //                 // margin: EdgeInsets.symmetric(horizontal: 10),
                  //                 // padding: const EdgeInsets.symmetric(
                  //                 //     horizontal: 25, vertical: 5),
                  //                 // decoration: BoxDecoration(
                  //                 //     border: Border.all(
                  //                 //       width: 1,
                  //                 // color: Color.fromARGB(255, 34, 104, 36),
                  //                 // ),
                  //                 // borderRadius:
                  //                 // const BorderRadius.all(Radius.circular(20.0))),

                  //                 child: const Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Padding(
                  //                       padding: EdgeInsets.symmetric(horizontal: 10),
                  //                       child: Text(
                  //                         'Log out',
                  //                         style: TextStyle(
                  //                           fontSize: 18,
                  //                           fontWeight: FontWeight.bold,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Icon(
                  //                       Icons.logout,
                  //                       // color: Color.fromARGB(255, 40, 122, 43),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //     ),
                  //   ],
                  // ),

                  // isAnonymous
                  //     ? GestureDetector(
                  //       onTap: ,
                  //       child: Icon(
                  //           Icons.account_circle,
                  //           size: 45,
                  //           color: Color.fromARGB(255, 163, 163, 163),
                  //         ),
                  //     )
                  //     : Icon(
                  //         Icons.account_circle,
                  //         size: 45,
                  //         color: Color.fromARGB(255, 48, 143, 51),
                  //       ),
                  // ),
                ],
                title: const Text(
                  '',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<BottomNavigationProvider>(
                builder: (context, provider, _) {
                  return Container(
                    // constraints: BoxConstraints(maxWidth: kIsWeb ? 700.0 : MediaQuery.of(context).size.width),
                    child: IndexedStack(
                      index: provider.selectedIndex,
                      children: const [
                        SelectCriteriaScreen(),
                        GroupsScreen(),
                        LeaderboardScreen(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        drawer: const MainDrawer(),
        bottomNavigationBar: Consumer<BottomNavigationProvider>(builder: (context, provider, _) {
          return Container(
            // constraints: BoxConstraints(
            //   maxWidth: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
            // ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: provider.selectedIndex,
              onTap: (index) {
                // provider.updateIndex(index);
                if (!isAnonymous || (index == 0 || index == 1)) {
                  provider.updateIndex(index);
                } else if (isAnonymous && (index == 2 || index == 3)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Zaloguj się aby korzystać z tych funkcji.'),
                      action: SnackBarAction(
                        label: 'Zaloguj',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                        },
                      ),
                    ),
                  );
                }
              },
              items: const [
                BottomNavigationBarItem(
                  // icon: Icon(Icons.emoji_events_rounded),
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(
                //     Icons.scoreboard_outlined,
                //   ),
                //   label: 'Predictions',
                // ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_rounded),
                  label: 'Groups',
                  //
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium_rounded),
                  label: 'Leaderboard',
                  //
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
