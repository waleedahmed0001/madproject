import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad_project/models/book.dart';
import 'package:mad_project/models/group.dart';
import 'package:mad_project/models/users.dart';

class OurDatabase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = "error";
    try {
      await _firebaseFirestore.collection("users").doc(user.uid).set({
        'fullName': user.fullName?.trim(),
        'email': user.email?.trim(),
        'accountCreated': Timestamp.now(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();
    try {
      DocumentSnapshot _documentSnapShot =
          await _firebaseFirestore.collection("users").doc(uid).get();
      Map<String, dynamic>? data =
          _documentSnapShot.data() as Map<String, dynamic>?;
      if (data != null) {
        retVal.fullName = data["fullName"];
        retVal.email = data["email"];
        retVal.accountCreated = data["accountCreated"];
        retVal.groupId = data["groupId"];
      }
    } catch (e) {}

    return retVal;
  }

  Future<String> createGroup(String groupName, String Uid, OurBook initialBook) async {
    String retVal = "error";
    List<String> members = [];
    List<String> tokens = [];
    try {
      members.add(Uid);
      DocumentReference documentReference =
          await _firebaseFirestore.collection("groups").add({
        'name': groupName.trim(),
        'leader': Uid,
        'members': members,
        'tokens': tokens,
        'groupCreated': Timestamp.now(),
      });
      await _firebaseFirestore
          .collection("users")
          .doc(Uid)
          .update({'groupId': documentReference.id});

                addBook(documentReference.id, initialBook);

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  /*
  Future<String> createGroup(
      String groupName, UserModel user, BookModel initialBook) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();

    try {
      members.add(user.uid);
      tokens.add(user.notifToken);
      DocumentReference _docRef;
      if (user.notifToken != null) {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'tokens': tokens,
          'groupCreated': Timestamp.now(),
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      } else {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'groupCreated': Timestamp.now(),
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      }

      await _firestore.collection("users").document(user.uid).updateData({
        'groupId': _docRef.documentID,
      });

      //add a book
      addBook(_docRef.documentID, initialBook);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
   */

  Future<String> joinGroup(String groupId, String Uid) async {
    String retVal = "error";
    List<String> members = [];
    List<String> tokens = [];
    try {
      members.add(Uid);
      await _firebaseFirestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
        // 'tokens': FieldValue.arrayUnion(tokens),
      });
      await _firebaseFirestore
          .collection("users")
          .doc(Uid)
          .update({'groupId': groupId});
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }


   Future<OurGroup> getGroupInfo(String groupId) async {
    OurGroup retVal = OurGroup();
    try {
      DocumentSnapshot _documentSnapShot =
          await _firebaseFirestore.collection("groups").doc(groupId).get();
      Map<String, dynamic>? data =
          _documentSnapShot.data() as Map<String, dynamic>?;
      if (data != null) {
        retVal.id=groupId;
        retVal.name = data["name"];
        retVal.leader = data["leader"];
        retVal.members = List<String>.from(data["members"]);
        retVal.groupCreated = data["groupCreated"];
        retVal.currentBookId = data["currentBookId"];
        retVal.currentBookDue = data["currentBookDue"];
        

      }
    } catch (e) {}

    return retVal;
  }



Future<String> addBook(String groupId, OurBook book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firebaseFirestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await _firebaseFirestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }



 Future<OurBook> getCurrentBook(String groupId,String bookId) async {
    OurBook retVal = OurBook();
    try {
      DocumentSnapshot _documentSnapShot =
          await _firebaseFirestore.collection("groups").doc(groupId).collection("books").doc(bookId).get();
      Map<String, dynamic>? data =
          _documentSnapShot.data() as Map<String, dynamic>?;
      if (data != null) {
        retVal.id=bookId;
        retVal.name = data["name"];
        retVal.length = data["length"];
        retVal.author = data["author"];        
        retVal.dateCompleted = data["dateCompleted"];
      
      }
    } catch (e) {}

    return retVal;
  }




 Future<String> finishedBook(
    String groupId,
    String bookId,
    String uid,
    int rating,
    String review,
  ) async {
    String retVal = "error";
    try {
      await _firebaseFirestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .set({
        'rating': rating,
        'review': review,
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

Future<bool> isUserDoneWithBook(
      String groupId, String bookId, String uid) async {
    bool retVal = false;
    try {
      DocumentSnapshot _docSnapshot = await _firebaseFirestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .get();

      if (_docSnapshot.exists) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }




/*
Future<String> joinGroup(String groupId, UserModel userModel) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();
    try {
      members.add(userModel.uid);
      tokens.add(userModel.notifToken);
      await _firestore.collection("groups").document(groupId).updateData({
        'members': FieldValue.arrayUnion(members),
        'tokens': FieldValue.arrayUnion(tokens),
      });

      await _firestore.collection("users").document(userModel.uid).updateData({
        'groupId': groupId.trim(),
      });

      retVal = "success";
    } on PlatformException catch (e) {
      retVal = "Make sure you have the right group ID!";
      print(e);
    } catch (e) {
      print(e);
    }

    return retVal;
  }
 */
}
