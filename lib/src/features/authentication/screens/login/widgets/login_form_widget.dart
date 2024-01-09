// import 'package:flutter/material.dart';

// class LoginForm extends StatelessWidget {
//   LoginForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         _entryField('e-mail', _controllerEmail, Icons.email),
//         const SizedBox(height: 20),
//         _entryField('password', _controllerPassword, Icons.password),
//         _errorMessage(),
//         TextButton(
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (context) => Padding(
//                 padding: MediaQuery.of(context).viewInsets,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(15),
//                         topRight: Radius.circular(15)),
//                     // color: Color.fromARGB(123, 22, 22, 22),
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(children: [
//                       const Text(
//                         'Zapomniałeś hasła?',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color.fromARGB(255, 200, 200, 200)),
//                       ),
//                       const SizedBox(height: 15),
//                       const Text(
//                         'Podaj adres e-mail, otrzymasz 6-cyfrowy kod weryfikacyjny',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Color.fromARGB(255, 200, 200, 200)),
//                       ),
//                       const SizedBox(height: 15),
//                       Form(
//                           child: Column(
//                         children: [
//                           TextFormField(
//                             controller: _controllerEmail,
//                             decoration: InputDecoration(
//                               hintText: "E-mail",
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(18),
//                                   borderSide: BorderSide.none),
//                               fillColor: Color.fromARGB(255, 48, 85, 50),
//                               filled: true,
//                               prefixIcon: const Icon(Icons.mail),
//                             ),
//                           ),
//                           const SizedBox(height: 50),
//                           SizedBox(
//                             width: 180,
//                             height: 50,
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 shape: const StadiumBorder(),
//                                 backgroundColor:
//                                     const Color.fromARGB(255, 40, 122, 43),
//                               ),
//                               child: const Text(
//                                 "Wyślij",
//                                 style: TextStyle(
//                                     fontSize: 20, color: Colors.white),
//                               ),
//                             ),
//                           )
//                         ],
//                       ))
//                     ]),
//                   ),
//                 ),
//               ),
//             );
//           },
//           style: TextButton.styleFrom(
//             alignment: Alignment.centerRight,
//           ),
//           child: const Text(
//             "Zapomniałeś hasła?",
//             style: TextStyle(color: Color.fromARGB(255, 58, 158, 61)),
//           ),
//         ),
//         const SizedBox(height: 5),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               shape: const StadiumBorder(),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: const Color.fromARGB(255, 40, 122, 43),
//             ),
//             child: const Text(
//               "Zaloguj",
//               style: TextStyle(fontSize: 20, color: Colors.white),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
