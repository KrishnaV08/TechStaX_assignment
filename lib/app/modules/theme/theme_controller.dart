import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // read saved preference, default to false
  bool get isDarkMode => _box.read(_key) ?? false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    Get.changeThemeMode(themeMode);
  }

  void toggleTheme() {
    final newMode = !isDarkMode;
    _box.write(_key, newMode);
    Get.changeThemeMode(newMode ? ThemeMode.dark : ThemeMode.light);
    update(); // triggers GetBuilder to rebuild
  }
}
