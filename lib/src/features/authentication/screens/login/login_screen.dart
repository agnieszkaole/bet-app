import 'package:bet_app/src/features/authentication/screens/login/widgets/continue_as_guest.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/login_form_widget.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/login_header_widget.dart';
import 'package:bet_app/src/features/authentication/screens/sign_up/singup_screen.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bet_app/src/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  // final TextEditingController _controllerName = TextEditingController();

  Widget _entryField(
    String title,
    TextEditingController controller,
    IconData icon,
    bool obscureText,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
        fillColor: Color.fromARGB(255, 48, 85, 50),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
    );
  }

  Future<User?> signInWithEmailAndPassword() async {
    try {
      User? user = await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        errorCallback: (errorMessageAuth) {
          setState(() {
            errorMessage = errorMessageAuth;
          });
        },
      );

      if (user != null) {
        print('User is logged in: ${user.uid}');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      }
      return user;
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      print('Error signing in: $e');
      return null;
    }
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Nieprawidłowy e-mail lub hasło.',
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: signInWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: const Color.fromARGB(255, 40, 122, 43),
        ),
        child: Text('Zaloguj'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const LoginHeader(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // _entryField('name', _controllerEmail, Icons.person, false),
                    // const SizedBox(height: 20),
                    _entryField('e-mail', _controllerEmail, Icons.email, false),
                    const SizedBox(height: 20),
                    _entryField(
                        'password', _controllerPassword, Icons.password, true),
                    const SizedBox(height: 10),
                    _errorMessage(),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 60),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                // color: Color.fromARGB(123, 22, 22, 22),
                              ),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  const Text(
                                    'Zapomniałeś hasła?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 200, 200, 200)),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Podaj adres e-mail, otrzymasz 6-cyfrowy kod weryfikacyjny',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 200, 200, 200)),
                                  ),
                                  const SizedBox(height: 15),
                                  Form(
                                      child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _controllerEmail,
                                        decoration: InputDecoration(
                                          hintText: "E-mail",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              borderSide: BorderSide.none),
                                          fillColor:
                                              Color.fromARGB(255, 48, 85, 50),
                                          filled: true,
                                          prefixIcon: const Icon(Icons.mail),
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                    ],
                                  ))
                                ]),
                              ),
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerRight,
                      ),
                      child: const Text(
                        "Zapomniałeś hasła?",
                        style:
                            TextStyle(color: Color.fromARGB(255, 58, 158, 61)),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signInWithEmailAndPassword,
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:
                              const Color.fromARGB(255, 40, 122, 43),
                        ),
                        child: const Text(
                          "Zaloguj",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Nie masz jeszcze konta? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                      },
                      child: const Text(
                        "Zarejestruj się",
                        style:
                            TextStyle(color: Color.fromARGB(255, 58, 158, 61)),
                      ),
                    ),
                  ],
                ),
                const Center(child: Text("Lub")),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromARGB(255, 228, 228, 228),
                    border: Border.all(
                      color: const Color.fromARGB(255, 40, 122, 43),
                    ),
                    boxShadow: [
                      BoxShadow(

                          // color: Colors.white.withOpacity(0.5),
                          // spreadRadius: 1,
                          // blurRadius: 1,
                          // offset: const Offset(0, 1), // changes position of shadow
                          ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(
                        //   height: 30.0,
                        //   width: 30.0,
                        //   decoration: const BoxDecoration(
                        //     image: DecorationImage(
                        //         image: AssetImage(
                        //             'assets/images/login_signup/google.png'),
                        //         fit: BoxFit.cover),
                        //     shape: BoxShape.circle,
                        //   ),
                        // ),
                        SizedBox(width: 18),
                        Text(
                          "Zaloguj się poprzez Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 40, 122, 43),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const ContinueAsGuestScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
