import 'package:flutter/material.dart';
import 'package:habit_tracker_app/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  //initially them is lightmode
  ThemeData _themeData = lightMode;

//getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  //getter method to check if the theme is in darkmode or not
  bool get isDarkMode => _themeData == darkMode;

  //setter methode to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

//we will use this toggle in the app later on
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
