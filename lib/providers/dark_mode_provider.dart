import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DarkModeProvider with ChangeNotifier {
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  DarkModeProvider() {
    _initDarkMode();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void _initDarkMode() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;

    _darkMode = brightness == Brightness.dark;
    notifyListeners();
  }
}