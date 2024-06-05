import 'package:flutter/foundation.dart';

class AnimeModeProvider with ChangeNotifier {
  bool _animeMode = true;
  bool get animeMode => _animeMode;

  set animeMode(bool value) {
    _animeMode = value;
    notifyListeners();
  }
}