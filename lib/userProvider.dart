import 'package:flutter/material.dart';
import 'package:pizzas/user.dart';

class UserProvider extends ChangeNotifier{
  User? _user;

  User get user => _user!;

  login(User user){
    _user = user;
    notifyListeners();
  }

}