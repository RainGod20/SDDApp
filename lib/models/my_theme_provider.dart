import 'package:flutter/material.dart';

class MyThemeModel extends ChangeNotifier {
  // Is the time right now more than 6 am and less than 8 pm
  bool _isLightTheme = DateTime.now().hour > 6 && DateTime.now().hour < 20 ? true : false;

  void changeTheme() {
    _isLightTheme = !_isLightTheme;
    notifyListeners();
  }

  bool get isLightTheme => _isLightTheme;
}
