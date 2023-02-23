import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/resources/storage_method.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart' as UserModel;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();
    return UserModel.User.fromSnap(snap);
  }

  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = 'some error occure';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilepics', file, false);

        final UserModel.User user = UserModel.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore
            .collection('user')
            .doc(cred.user!.uid)
            .set(user.toKson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> LoginUser(
      {required String email, required String password}) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> LogOutUser() async {
    return await _auth.signOut();
  }

  Future<String> updateProfile({
    required String uid,
    required String email,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = 'some error occure';

    try {
      if (file != null) {
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilepics', file, false);

        await _firestore.collection('user').doc(uid).update({
          'username': username,
          'uid': uid,
          'email': email,
          'bio': bio,
          'photoUrl': photoUrl,
        });
        res = 'success';
      } else {
        await _firestore.collection('user').doc(uid).update({
          'username': username,
          'uid': uid,
          'email': email,
          'bio': bio,
        });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
      print(err.toString());
    }
    return res;
  }
}
