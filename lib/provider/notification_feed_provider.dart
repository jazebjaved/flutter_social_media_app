import 'package:flutter/material.dart';
import '../models/notification_feed.dart';

class NotifyFeedCountProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  // UserModel.User? _user;
  // UserModel.User? get getUser => _user;

  getNotifyFeedList(int count) {
    _count = count;
    notifyListeners();
  }
}
