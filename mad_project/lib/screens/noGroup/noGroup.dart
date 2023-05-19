import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_project/screens/createGroup/createGroup.dart';
import 'package:mad_project/screens/joinGroup/joinGroup.dart';

class OurNoGroup extends StatelessWidget {
  const OurNoGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToJoin(BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>OurJoinGroup()));
    }
    void _goToCreate(BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>OurCreateGroup()));

    }
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: Image.asset("assets/logo.png"),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text("Welcome to Book Club",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.grey.shade600,
              ),)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Since you are not in a book club, you can select either "
                "to join a club or create a club",
                textAlign: TextAlign.center,
                style: TextStyle(
              fontSize: 20.0,
              color: Colors.grey.shade600,
            )),
          ),
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Set the desired border radius
                      ),
                    ),
                    onPressed: () {
                  _goToCreate(context);
                }, child: Text("Create")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Set the desired border radius
                      ),
                    ),
                    onPressed: () {
                  _goToJoin(context);
                }, child: Text("Join"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
