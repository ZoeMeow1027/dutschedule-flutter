import 'package:flutter/material.dart';

import '../utils/timer.dart';

abstract class BaseViewModel extends ChangeNotifier {
  late CoreTimer _timer;

  BaseViewModel() {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    _timer = CoreTimer(
      action: () {
        timerAction();
      },
    );
    initializing();
  }

  bool _isInitialized = false;

  void initializing();

  void timerAction();

  void startTimer({bool startOver = true}) {
    _timer.start(
      startOver: startOver,
    );
  }

  void stopTimer() {
    _timer.stop();
  }

  int get timerInterval => _timer.interval;

  set timerInterval(int value) {
    _timer.interval = value;
  }
}
