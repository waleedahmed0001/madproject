import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad_project/models/users.dart';
import 'package:mad_project/services/database.dart';

class CurrentUser extends ChangeNotifier{
	late OurUser? _currentUser = OurUser();

	OurUser? get getCurrentUser => _currentUser;
 	// String? get getUid => _currentUser?.uid;
	// String? get getEmail => _currentUser?.email;
	final FirebaseAuth _auth = FirebaseAuth.instance;
	Future<String> onStartUp() async {
		String retVal = "error";
		try {
			User? firebaseUser = await _auth.currentUser;
			if(firebaseUser != null){
				// _currentUser?.uid = firebaseUser.uid;
				// _currentUser?.email = firebaseUser.email;

        _currentUser = await OurDatabase().getUserInfo(firebaseUser.uid);
        if (_currentUser != null) {
					// _currentUser.uid =
          retVal = "success";
        }
      }
    } catch (e) {
			print(e);
		}
		return retVal;
	}



	Future<String> signOut() async {
		String retVal = "error";
		try{
			await _auth.signOut();
			_currentUser = OurUser();
			retVal = "success";
		} catch(e){
			print(e);
		}
		return retVal;
	}
	Future<String> signUpUser(String email, String password, String fullName) async {
		String retVal = "error";
		OurUser ourUser = OurUser();
		try {
			UserCredential autResult =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
			print("Auth Result is: ");
			print(autResult);
			ourUser.uid = autResult.user?.uid ?? "";
			ourUser.email = autResult.user?.email ?? "";
			ourUser.fullName = fullName;
			String returnString = await OurDatabase().createUser(ourUser);
			if(returnString=="success"){
				retVal = "success";
			}
		} catch (e) {
			retVal = e.toString();
		}
		return retVal;
	}
	Future<String> logInUserWithEmil(String email, String password) async {
		String retVal = "error";
		try {
			UserCredential _authResult =await _auth.signInWithEmailAndPassword(email: email, password: password);
			// _currentUser?.uid = _authResult.user?.uid;
			// _currentUser?.email = _authResult.user?.email;
			// retVal = "success";
			_currentUser = await OurDatabase().getUserInfo(_authResult.user!.uid);
			if(_currentUser != null){
				retVal = "success";
			}
		} catch (e) {
			retVal = e.toString();
		}
		return retVal;
	}



	Future<String> logInUserWithGoogle() async {
		String retVal = "error";
		GoogleSignIn _googleSignIn = GoogleSignIn(
			scopes: [
				'email',
				'https://www.googleapis.com/auth/contacts.readonly',
			],
		);

		OurUser user = OurUser();
		try {
			GoogleSignInAccount? googleSignInUser =  await _googleSignIn.signIn();
			GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInUser?.authentication;
			final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication?.idToken, accessToken: googleSignInAuthentication?.accessToken);

			UserCredential _authResult =
			await _auth.signInWithCredential(credential);
			_currentUser?.uid = _authResult.user?.uid;
			_currentUser?.email = _authResult.user?.email;
			retVal = "success";
			//
			// if(_authResult.additionalUserInfo?.isNewUser ?? false) {
			// 	user.uid = _authResult.user!.uid;
			// 	user.email = _authResult.user!.email!;
			// 	user.fullName = _authResult.user!.displayName;
			// 	OurDatabase().createUser(user);
			// }
			// _currentUser = await OurDatabase().getUserInfo(_authResult.user!.uid);
			if(_currentUser != null){
        retVal = "success";
      }
    } catch (e) {
			retVal = e.toString();
		}
		return retVal;
	}




	
}