import 'dart:async';

class CoreTimer {
  CoreTimer({Function()? action}) {
    _action = action;
  }

  Timer? _timer;
  int _ticksCurrent = 0;
  int _ticks = 0;
  Function()? _action;

  void start({bool startOver = true}) {
    if (_timer == null || !_timer!.isActive) {
      if (_ticks <= 0) {
        return;
      }
      if (startOver) {
        _ticksCurrent = _ticks;
      }
      _timer = Timer.periodic(Duration(milliseconds: 200), (t) {
        _ticksCurrent -= 200;
        // print("[Timer] Tick $_ticksCurrent");

        if (_ticksCurrent <= 0) {
          _action?.call();
          _ticksCurrent = _ticks;
        }
      });
      // Timer is started running!
    } else {
      // Timer is already running!
    }
  }

  void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null; // Reset the timer
    } else {
      // Timer is not running!
    }
  }

  int get interval => _ticks;

  set interval(int value) {
    if (_ticks != value) {
      _ticks = value;
      _ticksCurrent = _ticks;
      print("Timer changed to ${value}s!");
    }
  }

  bool get isRunning => _timer != null;
}
