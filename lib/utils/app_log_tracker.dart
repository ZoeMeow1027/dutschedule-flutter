
enum AppLogLevel {
  error(4),
  warning(3),
  info(2),
  debug(1),
  verbose(0);

  final int value;
  const AppLogLevel(this.value);
}

class AppLogItem {
  int dateCreated;
  AppLogLevel logLevel;
  String logSource;
  String message;

  AppLogItem({
    required this.dateCreated,
    required this.logLevel,
    required this.logSource,
    required this.message,
  });
}

class AppLogTracker {
  String fileName;
  List<AppLogItem> itemList = [];

  AppLogTracker({
    required this.fileName,
  });

  void addLog(AppLogItem item) {
    itemList.add(item);
  }

  void removeAllLog() {
    itemList.clear();
  }
}