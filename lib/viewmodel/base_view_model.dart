import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  BaseViewModel() {
    if (_isInitialized >= 0) {
      return;
    }
    _isInitialized = 0;
    initializing();

    _isInitialized = 1;
  }

  void initializing();

  void timerAction();

  // Check if initialized.
  // -1: Not initialized yet, 0: Initializing, 1: Initialized.
  int _isInitialized = -1;

  bool get isInitialized => _isInitialized == 1;
}
