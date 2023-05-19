import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mad_project/screens/addBook/addBook.dart';
import 'package:mad_project/screens/noGroup/noGroup.dart';
import 'package:mad_project/screens/root/root.dart';
import 'package:mad_project/utils/timeLeft.dart';
import 'package:mad_project/widgets/OurContainer.dart';
import 'package:provider/provider.dart';

import '../../states/currentGroup.dart';
import '../../states/currentUser.dart';
import '../review/review.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> { 
List<String?> _timeUntil = List<String?>.filled(2, null);

Timer? _timer;

void _startTimer(CurrentGroup currentGroup){
  _timer=Timer.periodic(Duration(seconds: 1), (timer) { 
setState(() {
  _timeUntil = OurTimeLeft().timeLeft(currentGroup.getCurrentGroup.currentBookDue!.toDate());
});
  });
}

@override
void initState() {
  super.initState();
  CurrentUser _currentUser=Provider.of<CurrentUser>(context,listen: false);

    CurrentGroup _currentGroup=Provider.of<CurrentGroup>(context,listen: false);
  _currentGroup.updateStateFromDatabase(_currentUser.getCurrentUser?.groupId ?? "",_currentUser.getCurrentUser?.uid ?? "");
  _startTimer(_currentGroup);

}

@override
void dispose(){
  _timer?.cancel();
  super.dispose();
}
  
  void _signOut(BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => OurRoot()), (route) => false);
    }
  }

  void _goToAddBook(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => OurAddBook(onGroupCreation: false,)));
  }

  void _goToReview(){
        CurrentGroup _currentGroup=Provider.of<CurrentGroup>(context,listen: false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => OurReview(currentGroup:_currentGroup,)));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
                child: Consumer(
                  builder: (BuildContext context,CurrentGroup value, Widget? child) {return Column(
                              children: [
                  Text(
                    value.getCurrentBook.name ?? "Loading...",
                    style: TextStyle(fontSize: 30, color: Colors.grey.shade600),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "Out In: ",
                          style: TextStyle(
                              fontSize: 30, color: Colors.grey.shade600),
                        ),
                        Expanded(
                          child: Text(
                            _timeUntil[0] ?? "Loading...",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Set the desired border radius
                        ),
                      ),
                      // onPressed: () async {
                      //   // _signOut(context);
                      // },
                      child: const Text(
                        "Finished Book",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed:value.getDoneWithCurrentBook?null:_goToReview
                      )
                              ],
                            ); } , 
                    )),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: 
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Next Book\nRevealed In",
                        style: TextStyle(
                            fontSize: 30, color: Colors.grey.shade600),
                      ),
                      Text(_timeUntil[1] ?? "Loading...",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold))
                    ],
                  ),
              ),



            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired border radius
                ),
              ),

                onPressed: () async {
                  _goToAddBook(context);
                },
                child: const Text("Book Club History",
                style: TextStyle(color: Colors.white),),

            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
                onPressed: () async {
                  _signOut(context);
                },
                child: const Text("Sign Out", style: TextStyle(color: Colors.black87),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).canvasColor, // Set the desired background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired border radius
                     side: BorderSide(
                       color: Theme.of(context).secondaryHeaderColor,
                       width: 2
                     )
                  ),
                ),

            ),
          ),
        ],
      ),
    );
  }
}
