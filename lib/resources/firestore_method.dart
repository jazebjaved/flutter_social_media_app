import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/misc/utils.dart';
import 'package:first_app/resources/storage_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> UploadPost(
      {required String description,
      required String uid,
      required String profImage,
      required String username,
      required Uint8List file}) async {
    String res = 'some error occure';
    try {
      if (description.isNotEmpty) {
        String postPicUrl =
            await StorageMethods().uploadImageToStorage('post', file, true);

        String postId = const Uuid().v1();
        Post post = Post(
          description: description,
          username: username,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now(),
          postPicUrl: postPicUrl,
          photoUrl: profImage,
          likes: [],
        );

        await _firestore.collection('post').doc(postId).set(post.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> PostComment(String profPic, String name, String uid,
      String postId, String text) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'name': name,
          'commentId': commentId,
          'profPic': profPic,
          'uid': uid,
          'postId': postId,
          'text': text,
          'datePublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(
      String uid, String postId, BuildContext context) async {
    try {
      if (_auth.currentUser!.uid == uid) {
        await _firestore.collection('post').doc(postId).delete();
        ShowSnackBar('Many congragulation pot deleted', context);
      } else {
        ShowSnackBar('You are not allow to delete', context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteComment(
      String uid, String postId, String commentId, BuildContext context) async {
    try {
      if (_auth.currentUser!.uid == uid) {
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .delete();
        ShowSnackBar('Many congragulation pot deleted', context);
      } else {
        ShowSnackBar('You are not allow to delete', context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          // following means that i follow other people
          await _firestore.collection('user').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
