import 'package:flutter/material.dart';
import 'package:order_it_2/themes/dark_theme.dart';
import 'package:order_it_2/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData (ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}