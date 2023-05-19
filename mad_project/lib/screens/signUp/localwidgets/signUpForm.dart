import 'package:flutter/material.dart';
import 'package:mad_project/screens/signUp/signup.dart';
import 'package:mad_project/states/currentUser.dart';
import 'package:mad_project/widgets/OurContainer.dart';
import 'package:provider/provider.dart';

class OurSignUpForm extends StatefulWidget {
  const OurSignUpForm({Key? key}) : super(key: key);

  @override
  State<OurSignUpForm> createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _signUpUser(
      String email, String password, BuildContext context, String fullName) async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String returningString = await currentUser.signUpUser(email, password, fullName);
      if (returningString == "success") {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(returningString ?? "Google Log IN"),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Text(
            "Sign Up",
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
            prefixIcon: Icon(Icons.person_outline),
            hintText: "Full Name",
          ),
          controller: _fullNameController,
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
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock_open),
            hintText: "Confirm Password",
          ),
          obscureText: true,
          controller: _confirmPasswordController,
        ),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          onPressed: () {
            if (_passwordController.text == _confirmPasswordController.text) {
              _signUpUser(
                  _emailController.text, _passwordController.text, context, _fullNameController.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Passwords Do Not Match"),
                duration: Duration(seconds: 2),
              ));
            }
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
        ),
      ],
    ));
  }
}
