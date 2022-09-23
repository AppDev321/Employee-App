import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../custom_style/colors.dart';

class NavigationProvider extends ChangeNotifier {
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;


    notifyListeners();
  }
}
