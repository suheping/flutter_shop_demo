import 'package:flutter/material.dart';

class IndexProvider with ChangeNotifier {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;
}
