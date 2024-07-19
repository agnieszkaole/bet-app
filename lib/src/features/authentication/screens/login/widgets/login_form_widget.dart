import 'package:bet_app/src/constants/app_colors.dart';
import 'package:bet_app/src/features/authentication/screens/login/widgets/forget_password.dart';
import 'package:bet_app/src/features/authentication/screens/register/register_screen.dart';
import 'package:bet_app/src/provider/bottom_navigation_provider.dart';
import 'package:bet_app/src/screens/home_screen.dart';
import 'package:bet_app/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String errorMessage = '';
  bool _passwordVisible = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  void showHomeScreen(BuildContext context) {
    // saveUserSession(token);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    ));
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    IconData icon,
    bool isPassword,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: title,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        fillColor: const Color.fromARGB(110, 9, 126, 30),
        filled: true,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null, // Only show suffix icon if it's a password field
      ),
      obscureText: isPassword ? !_passwordVisible : false,
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : errorMessage,
      // "",
      style: const TextStyle(
        color: Colors.red,
      ),
      textAlign: TextAlign.left,
    );
  }

  // var predictedMatchProvider = Provider.of<PredictedMatchProvider>(context);
  // if (predictedMatchProvider.predictedMatchList.isNotEmpty) {
  //   predictedMatchProvider.predictedMatchList.clear();
  // }

  Future<String?> signInUser(BuildContext context) async {
    // var bottomNavigationIndex =
    //     Provider.of<BottomNavigationProvider>(context).selectedIndex;
    if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
      setState(() {
        errorMessage = "All fields must be completed.";
      });
      return errorMessage;
    }
    try {
      User? user = await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );

      if (user != null) {
        print('User is logged in: ${user.uid}');
        Provider.of<BottomNavigationProvider>(context, listen: false).updateIndex(0);
        showHomeScreen(context);
        return null;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Email address is invalid.";
          break;
        case "wrong-password":
          print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Password is invalid.";
          break;
        case "too-many-requests":
          print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Access blocked due to unusual activity. Please try again later.";
          break;
        case "invalid-credential":
          print('FirebaseAuthException: ${e.message}, code: ${e.code}');
          errorMessage = "Invalid email or password.";
          break;
        default:
          print(e.code);
          errorMessage = "Login failed. Please try again.";
          break;
      }
      setState(() {
        errorMessage = errorMessage;
      });
      return errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _entryField('Email', _controllerEmail, Icons.email, false),
        const SizedBox(height: 20),
        _entryField('Password', _controllerPassword, Icons.lock, true),
        const SizedBox(height: 5),
        _errorMessage(),
        // const Text(
        //   'By loggin, you confirm that you agree with our Privacy Policy and Terms of Use.',
        //   style: TextStyle(fontSize: 12),
        // ),
        // const SizedBox(height: 20),
        SizedBox(
          height: 35,
          child: Align(
            alignment: Alignment.topRight,
            child: ForgetPassword(email: _controllerEmail.text),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              signInUser(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.greenDark,
            ),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ));
              },
              child: const Text(
                'Sign up',
                style: TextStyle(color: AppColors.green),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
