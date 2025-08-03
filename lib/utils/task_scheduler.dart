import 'dart:async';

import '../model/enum/app_log_level.dart';
import 'app_utils.dart';

class _TaskSchedulerItem {
  final String name;
  Duration interval;
  Function() callback;
  Timer? timer;

  _TaskSchedulerItem({
    required this.name,
    required this.interval,
    required this.callback,
  });

  void start() {
    stop();
    timer = Timer.periodic(interval, (_) => callback());
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Task Scheduler',
      subTag: name,
      message: 'Task started, every ${interval.inMinutes} minute(s).',
    );
  }

  void stop() {
    timer?.cancel();
    timer = null;
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Task Scheduler',
      subTag: name,
      message: 'Task stopped.',
    );
  }

  void update(Duration newInterval) {
    interval = newInterval;
    start();
  }

  void triggerNow() {
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Task Scheduler',
      subTag: name,
      message: 'Task triggered.',
    );
    callback();
  }

  bool get isRunning => timer?.isActive ?? false;
}

class TaskScheduler {
  static final TaskScheduler _instance = TaskScheduler._internal();
  factory TaskScheduler() => _instance;
  TaskScheduler._internal();

  final Map<String, _TaskSchedulerItem> _tasks = {};

  bool get isEmpty => _tasks.isEmpty;

  void addTask({
    required String name,
    required Duration interval,
    required Function() callback,
    bool triggerAfterCreated = false,
  }) {
    if (_tasks.containsKey(name)) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Task Scheduler',
        subTag: name,
        message: 'Task "$name" is already exists! Please remove this task if you want that name.',
      );
      return;
    }
    if (interval.inMinutes < 1) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Task Scheduler',
        subTag: name,
        message: 'Task must not shorter than 1 minute!',
      );
      return;
    }
    final task = _TaskSchedulerItem(name: name, interval: interval, callback: callback);
    _tasks[name] = task;
    task.start();

    if (triggerAfterCreated) {
      callback();
    }
  }

  void removeTask(String name) {
    final task = _tasks.remove(name);
    task?.stop();
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Task Scheduler',
      subTag: name,
      message: 'Task removed.',
    );
  }

  bool containsTask(String name) {
    try {
      final temp = _tasks[name];
      return temp != null;
    } catch (_) {
      return false;
    }
  }

  void updateTaskInterval(String name, Duration newInterval) {
    if (newInterval.inMinutes < 1) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Task Scheduler',
        subTag: name,
        message: 'Task must not shorter than 1 minute!',
      );
      return;
    }

    final task = _tasks[name];
    if (task != null) {
      task.update(newInterval);
    }
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Task Scheduler',
      subTag: name,
      message: 'Task duration changed to ${newInterval.toString()} minute(s).',
    );
  }

  void triggerTaskNow(String name) {
    _tasks[name]?.triggerNow();
  }

  void stopAll() {
    for (final task in _tasks.values) {
      task.stop();
    }
  }

  void startAll() {
    for (final task in _tasks.values) {
      task.start();
    }
  }

  bool isTaskRunning(String name) => _tasks[name]?.isRunning ?? false;
}
