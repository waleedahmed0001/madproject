import 'package:flutter/material.dart';
import 'package:mad_project/screens/login/login.dart';
import 'package:mad_project/screens/root/root.dart';
import 'package:mad_project/states/currentUser.dart';
import 'package:mad_project/utils/ourTheme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
	create: (context) => CurrentUser(),
	child:MaterialApp(
      	title: 'Flutter Demo',
      	theme: OurTheme().buildTheme(),
      	home: OurRoot()
    	)
	);
  }
}
