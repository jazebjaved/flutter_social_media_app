import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screen/notification_feed_screen.dart';
import 'package:first_app/resources/auth.method.dart';
import 'package:flutter/material.dart';

class CommentsProvider with ChangeNotifier {
  int? _commenLength;
  int get getComment => _commenLength!;

  Future refreshComments(String postId) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('comments')
        .get();
    int commenLength = snap.docs.length;
    _commenLength = commenLength;
    notifyListeners();
  }
}
