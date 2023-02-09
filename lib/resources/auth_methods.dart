import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/user_model.dart' as user;
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<user.UserModel> getUserData() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return user.UserModel.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImagetoStorage("profilePic", file);

        Map<String, dynamic> json = user.UserModel(
          email: email,
          uid: cred.user!.uid,
          username: username,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        ).toJson();

        _firestore.collection("users").doc(cred.user!.uid).set(json);
        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> logInUser({
    required email,
    required password,
  }) async {
    String res = "Some Error Occured";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
