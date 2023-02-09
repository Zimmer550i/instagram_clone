import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    _user = await AuthMethods().getUserData();
    notifyListeners();
  }
}
