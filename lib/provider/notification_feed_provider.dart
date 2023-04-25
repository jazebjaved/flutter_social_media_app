import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:flutter/material.dart';

class NotifyFeedCountProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  // UserModel.User? _user;
  // UserModel.User? get getUser => _user;

  Future getNotifyFeedList() async {
    QuerySnapshot snap = await FirestoreMethods().getUnreadNotificationAmount();
    int count = snap.docs.length;
    _count = count;
    notifyListeners();
  }
}
