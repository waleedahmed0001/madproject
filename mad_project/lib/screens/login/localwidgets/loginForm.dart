import 'package:flutter/material.dart';
import 'package:mad_project/screens/home/home.dart';
import 'package:mad_project/screens/root/root.dart';
import 'package:mad_project/screens/signUp/signup.dart';
import 'package:mad_project/states/currentUser.dart';
import 'package:mad_project/widgets/OurContainer.dart';
import 'package:provider/provider.dart';

enum LogInType { email, google }

class OurLogInForm extends StatefulWidget {
  const OurLogInForm({Key? key}) : super(key: key);

  @override
  State<OurLogInForm> createState() => _OurLogInFormState();
}

class _OurLogInFormState extends State<OurLogInForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser({
    required LogInType type,
    String? email,
    String? password,
    required BuildContext context,
  }) async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    try {
      String? success;

      switch (type) {
        case LogInType.email:
          success = await currentUser.logInUserWithEmil(email!, password!);
          break;
        case LogInType.google:
          await currentUser.logInUserWithGoogle();
          break;
      }

      if (success == "success") {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OurRoot()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success ?? "Google LogIn"),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  // Widget _googleButton() {
  //   return OutlinedButton(
  //     splashColor: Colors.grey,
  //     onPressed: () {
  //       _loginUser(type: LoginType.google, context: context);
  //     },
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
  //     highlightElevation: 0,
  //     borderSide: BorderSide(color: Colors.grey),
  //     child: Padding(
  //       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 10),
  //             child: Text(
  //               'Sign in with Google',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _googleButton() {
    return OutlinedButton(
      onPressed: () {
        _loginUser(type: LogInType.google, context: context);
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        side: BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
              image: AssetImage("assets/google_logo.png"),
              height: 25.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<void> _loginUser(String email, String password, BuildContext context) async {
  //   CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
  //   try {
  //     if (await _currentUser.logInUserWithEmil(email, password)) {
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => HomeScreen()));
  //     }
  //     else{
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Incorrect Password"),
  //         duration: Duration(seconds: 2),
  //       ));
  //     }
  //   } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Text(
            "Log In",
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.alternate_email),
            hintText: "Email",
          ),
          controller: _emailController,
        ),
        const SizedBox(
          height: 20.0,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            hintText: "Password",
          ),
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
            onPressed: () {
              _loginUser(
                  type: LogInType.email,
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context);
            },
            child: const Text(
              "Log In",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            )),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OurSignUp()),);
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => OurSignUp()),
              //     (route) => false);
            },
            child: const Text("Don't have an account? Sign up here")),
        // _googleButton()
      ],
    ));
  }
}
