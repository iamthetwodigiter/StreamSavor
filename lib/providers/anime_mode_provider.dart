import 'package:flutter/foundation.dart';

class AnimeModeProvider with ChangeNotifier {
  bool _animeMode = false;
  bool get animeMode => _animeMode;

  set animeMode(bool value) {
    _animeMode = value;
    notifyListeners();
  }
}