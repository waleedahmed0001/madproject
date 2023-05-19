// import 'package:book_club/models/userModel.dart';
// import 'package:book_club/screens/root/root.dart';
// import 'package:book_club/services/dbFuture.dart';
// import 'package:book_club/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import '../../states/currentUser.dart';
import '../root/root.dart';

class OurJoinGroup extends StatefulWidget {

  // final UserModel userModel;

  // JoinGroup({this.userModel});
  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<OurJoinGroup> {
  // void _joinGroup(BuildContext context, String groupId) async {
  //   // UserModel _currentUser = widget.userModel;
  //   String _returnString = await DBFuture().joinGroup(groupId, _currentUser);
  //   if (_returnString == "success") {
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => OurRoot(),
  //         ),
  //             (route) => false);
  //   } else {
  //     _scaffoldKey.currentState.showSnackBar(
  //       SnackBar(
  //         content: Text(_returnString),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }

  TextEditingController _groupIdController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _joinGroup(BuildContext context, String groupId) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? uid = _currentUser.getCurrentUser?.uid;
    if (uid != null) {
      String returnString = await OurDatabase().joinGroup(groupId, uid);
      if(returnString=="success"){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()), (route) => false);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(returnString),
          duration: const Duration(seconds: 2),
        ));
      }
      // Rest of your code using the returnString
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error! User ID Not Found"),
        duration: const Duration(seconds: 2),
      ));
      // Handle the case when uid is null
      // For example, show an error message or handle the situation accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _groupIdController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Group Id",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        "Join",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _joinGroup(context, _groupIdController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}