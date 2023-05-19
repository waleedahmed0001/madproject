import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_project/screens/signUp/localwidgets/signUpForm.dart';

import '../../widgets/OurContainer.dart';
import '../login/localwidgets/loginForm.dart';

class OurSignUp extends StatelessWidget {
  const OurSignUp({Key? key}) : super(key: key);

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        BackButton(),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    OurSignUpForm()
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
