import 'dart:io';

// import 'package:book_club/models/authModel.dart';
// import 'package:book_club/models/groupModel.dart';
// import 'package:book_club/models/userModel.dart';
// import 'package:book_club/screens/inGroup/inGroup.dart';
// import 'package:book_club/screens/login/login.dart';
// import 'package:book_club/screens/noGroup/noGroup.dart';
// import 'package:book_club/screens/splashScreen/splashScreen.dart';
// import 'package:book_club/services/dbStream.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mad_project/screens/home/home.dart';
import 'package:mad_project/screens/noGroup/noGroup.dart';
import 'package:mad_project/screens/splashScreen/splashScreen.dart';
import 'package:mad_project/states/currentUser.dart';
import 'package:provider/provider.dart';

import '../../states/currentGroup.dart';

import '../login/login.dart';

enum AuthStatus { unknown, notLoggedIn, loggedIn, notInGroup, inGroup }

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;
  // AuthStatus _authStatus = AuthStatus.unknown;
  late String currentUid;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  // void initState() {
  //   super.initState();
  //
  //   if (Platform.isIOS) {
  //     _firebaseMessaging
  //         .requestNotificationPermissions(IosNotificationSettings());
  //     _firebaseMessaging.onIosSettingsRegistered.listen((event) {
  //       print("IOS Registered");
  //     });
  //   }
  //
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //     },
  //   );
  // }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String returnString = _currentUser.onStartUp() as String;
    if(returnString=="success"){
      if(_currentUser.getCurrentUser?.groupId!=null){
        setState(() {
          _authStatus = AuthStatus.inGroup;
        });
      }
      else{
        setState(() {
          _authStatus = AuthStatus.notInGroup;
        });
      }
    }
    else{
      _authStatus = AuthStatus.notLoggedIn;
    }
  }

  @override
  Widget build(BuildContext context) {

    // return Widget();
    Widget? retVal;
    // retVal = OurLogin();
    //


    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = OurSplashScreen();
        break;
        case AuthStatus.notLoggedIn:
        retVal = OurLogin();
        break;
      case AuthStatus.notInGroup:
        retVal = OurNoGroup();
        break;
        case AuthStatus.inGroup:
        retVal = ChangeNotifierProvider(create: (context)=>CurrentGroup(),child: HomeScreen());
        break;
      default:
    }
    // return retVal;
    return retVal ?? Container(); // Return a default Container if retVal is null

  }
}

// class LoggedIn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     UserModel _userStream = Provider.of<UserModel>(context);
//     Widget retVal;
//     if (_userStream != null) {
//       if (_userStream.groupId != null) {
//         retVal = StreamProvider<GroupModel>.value(
//           value: DBStream().getCurrentGroup(_userStream.groupId),
//           child: InGroup(),
//         );
//       } else {
//         retVal = NoGroup();
//       }
//     } else {
//       retVal = SplashScreen();
//     }
//
//     return retVal;
//   }
// }