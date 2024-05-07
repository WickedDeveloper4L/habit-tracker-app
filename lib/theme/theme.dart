import 'package:flutter/material.dart';

//lightMode

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        primary: Colors.grey.shade500,
        secondary: Colors.grey.shade200,
        tertiary: Colors.white,
        background: Colors.grey.shade300,
        inversePrimary: Colors.grey.shade900));

//dark mode
ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        primary: Colors.grey.shade600,
        secondary: Colors.grey.shade700,
        tertiary: Colors.grey.shade800,
        background: Colors.grey.shade900,
        inversePrimary: Colors.grey.shade300));
