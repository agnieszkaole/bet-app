import 'package:bet_app/src/features/authentication/screens/login/widgets/login_google_widget.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    "Zarejestruj się",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Stwórz swoje konto",
                    style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  TextFormField(
                    // style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: "Nazwa użytkownika",
                        // hintStyle: TextStyle(color: Colors.grey[200]),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Color.fromARGB(255, 48, 85, 50),
                        filled: true,
                        prefixIcon: const Icon(Icons.person)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Color.fromARGB(255, 48, 85, 50),
                        filled: true,
                        prefixIcon: const Icon(Icons.email)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Hasło",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Color.fromARGB(255, 48, 85, 50),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Potwierdź hasło",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Color.fromARGB(255, 48, 85, 50),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Zarejestruj",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromARGB(255, 40, 122, 43),
                    ),
                  )),
              const Center(child: Text("Lub")),

              const LoginGoogle(),
              // const Center(child: Text("Lub")),
              // Container(
              //   height: 45,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(25),
              //     color: Color.fromARGB(255, 228, 228, 228),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 40, 122, 43),
              //     ),
              //     boxShadow: [
              //       BoxShadow(

              //           // color: Colors.white.withOpacity(0.5),
              //           // spreadRadius: 1,
              //           // blurRadius: 1,
              //           // offset: const Offset(0, 1), // changes position of shadow
              //           ),
              //     ],
              //   ),
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         // Container(
              //         //   height: 30.0,
              //         //   width: 30.0,
              //         //   decoration: const BoxDecoration(
              //         //     image: DecorationImage(
              //         //         image: AssetImage(
              //         //             'assets/images/login_signup/google.png'),
              //         //         fit: BoxFit.cover),
              //         //     shape: BoxShape.circle,
              //         //   ),
              //         // ),
              //         SizedBox(width: 18),
              //         Text(
              //           "Zaloguj się poprzez Google",
              //           style: TextStyle(
              //             fontSize: 16,
              //             color: Color.fromARGB(255, 40, 122, 43),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Masz już konto?"),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Zaloguj",
                        style: TextStyle(
                          color: Color.fromARGB(255, 40, 122, 43),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
