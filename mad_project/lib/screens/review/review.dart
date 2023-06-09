import 'package:flutter/material.dart';
import 'package:mad_project/states/currentGroup.dart';
import 'package:mad_project/states/currentUser.dart';
import 'package:provider/provider.dart';


class OurReview extends StatefulWidget {
  CurrentGroup? currentGroup;

  OurReview({this.currentGroup});


  @override
  _OurReviewState createState() => _OurReviewState();
}

class _OurReviewState extends State<OurReview> {
TextEditingController _reviewController = TextEditingController();
int? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Rate book 1-10:"),
                      DropdownButton<int>(
                        value: _dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).canvasColor,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                        items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.group),
                      hintText: "Add A Review",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Add Review",
                        style: TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      String uid= Provider.of<CurrentUser>(context,listen: false).getCurrentUser!.uid.toString();
                      widget.currentGroup!.finishedBook(uid,_dropdownValue!, _reviewController.text);
                          // _goToAddBook(context, _groupNameController.text);
                    }
                        // _goToAddBook(context, _groupNameController.text),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

}