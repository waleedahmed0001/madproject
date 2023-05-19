// import 'package:book_club/screens/addBook/addBook.dart';
// import 'package:book_club/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mad_project/models/book.dart';
import 'package:mad_project/screens/root/root.dart';
import 'package:mad_project/services/database.dart';
import 'package:mad_project/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class OurAddBook extends StatefulWidget {
    final bool? onGroupCreation;
  // final bool onError;
  final String? groupName;
  // final UserModel currentUser;

   OurAddBook({
    this.onGroupCreation,
    // this.onError,
    this.groupName,
    // this.currentUser,
  });
  @override
  _OurAddBookState createState() => _OurAddBookState();
  
}

class _OurAddBookState extends State<OurAddBook> {

  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

Future<void> _selectDate() async{
final DateTime? picked = await DatePicker.showDatePicker(context, showTitleActions: true);
  if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      
      });
}
}


  void _addBook(BuildContext context, String groupName,OurBook book) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String? uid = _currentUser.getCurrentUser?.uid;
    if (uid != null) {
      // String returnString = await OurDatabase().createGroup(groupName, uid,book);
      String _returnString;
if (widget.onGroupCreation!){
_returnString = await OurDatabase().createGroup(groupName, _currentUser.getCurrentUser!.uid!,book);
}
else{
  _returnString = await OurDatabase().createGroup(groupName, _currentUser.getCurrentUser!.groupId!,book);

}

      if(_returnString=="success"){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OurRoot()), (route) => false);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_returnString),
          duration: const Duration(seconds: 2),
        ));
      }
      // Rest of your code using the returnString
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error in creating group, UID not found."),
        duration: const Duration(seconds: 2),
      ));
      // Handle the case when uid is null
      // For example, show an error message or handle the situation accordingly
    }
  }


  // void _goToAddBook(BuildContext context, String groupName) async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => OurAddBook(
  //         onGroupCreation: true,
  //         onError: false,
  //         groupName: groupName,
  //       ),
  //     ),
  //   );
  // }

  // TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      // body: Column(
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
                    controller: _bookNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Book Name",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Author",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Lenght",
                    ), keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
                  Text(DateFormat("H:mm").format(_selectedDate)),
                  TextButton(
                    child:Text("Change Date"),
                    onPressed:(){ _selectDate();},),
                  ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Create",
                        style: TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      
                      OurBook book = OurBook();
                         book.name = _bookNameController.text;
                        book.author = _authorController.text;
                        book.length = int.parse(_lengthController.text);
                        book.dateCompleted = Timestamp.fromDate(_selectedDate);
                          _addBook(context, widget.groupName!,book);
                    },
                        // _goToAddBook(context, _groupNameController.text),
                  ),
                ],
              ),
            ),
          ),]
    );
  }
}