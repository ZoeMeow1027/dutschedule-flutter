import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  BaseViewModel() {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    initializing();
  }

  bool _isInitialized = false;

  void initializing();

  void timerAction();
}
