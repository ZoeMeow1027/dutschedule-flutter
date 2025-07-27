import '../model/notification_history.dart';
import '../repository/storage_repository.dart';
import '../utils/app_utils.dart';
import 'base_view_model.dart';

class NotificationInstance extends BaseViewModel {
  NotificationInstance();

  NotificationInstance.fromCache({required List<NotificationHistory> cache}) {
    _fromMap(cache);
    _isStorageInitialized = true;
  }

  bool _isStorageInitialized = false;

  @override
  void initializing() {
    _isStorageInitialized = true;
  }

  @override
  void timerAction() {}

  List<NotificationHistory> notificationHistoryList = [];

  void addNotification(NotificationHistory filter) {
    if (!notificationHistoryList.any((p) => p.isEqualId(filter))) {
      notificationHistoryList.add(filter);
      _settingsChanged();
    }
  }

  void removeNotification(NotificationHistory filter) {
    if (notificationHistoryList.any((p) => p.isEqualId(filter))) {
      notificationHistoryList.removeWhere((p) => p.isEqualId(filter));
      _settingsChanged();
    }
  }

  void removeAllNotifications() {
    if (notificationHistoryList.isNotEmpty) {
      notificationHistoryList.clear();
      _settingsChanged();
    }
  }

  bool _pendingChanges = false;

  void _settingsChanged() async {
    if (!_isStorageInitialized) {
      return;
    }
    while (_pendingChanges) {
      await Future.delayed(Duration(milliseconds: 100));
      // return;
    }

    _pendingChanges = true;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Notification history',
      message: 'Modified changes! Saving...',
    );
    await StorageRepository.saveNotificationHistory(notifyHistory: notificationHistoryList);

    _pendingChanges = false;
    notifyListeners();
  }

  void _fromMap(List<NotificationHistory> cache) {
    notificationHistoryList.clear();
    notificationHistoryList.addAll(cache);
  }
}
