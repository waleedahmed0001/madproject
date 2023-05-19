import 'package:flutter/material.dart';
import 'package:mad_project/screens/login/localwidgets/loginForm.dart';

class OurLogin extends StatelessWidget {
  const OurLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Image.asset("assets/logo.png"),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                OurLogInForm()
              ],
            ),
          ))
        ],
      ),
    );
  }
}
