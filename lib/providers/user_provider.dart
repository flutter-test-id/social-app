import 'package:flutter/material.dart';

import 'package:social_app/model/user.dart';
import 'package:social_app/resourcers/auth_methods.dart';

class UserProvider extends ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}