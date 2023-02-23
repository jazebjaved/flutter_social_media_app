import 'package:first_app/resources/auth.method.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  UserModel.User? _user;
  UserModel.User get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
