import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    debugPrint("NavigationProvider: Switching to index $index");
    _currentIndex = index;
    notifyListeners();
  }
}
