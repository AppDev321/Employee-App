import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../custom_style/colors.dart';
import '../utils/controller.dart';

class ThemeModel extends ChangeNotifier {
  late bool _isDark;
  late Controller _preferences;
  bool get isDark => _isDark;

  ThemeModel() {
    _isDark = false;
    _preferences = Controller();
    getPreferences();
  }

//Switching themes in the flutter apps - Flutterant
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);


    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();

    notifyListeners();
  }
}
