import '../model/notification_history.dart';
import 'base_view_model.dart';

class NotificationInstance extends BaseViewModel {
  bool _isSettingsInitialized = false;

  @override
  void initializing() {
    // TODO: implement initializing
    _isSettingsInitialized = true;
  }

  @override
  void timerAction() {
    // TODO: implement timerAction
  }

  List<NotificationHistory> notificationHistoryList = [];

  void addNotification(NotificationHistory filter) {
    notificationHistoryList.add(filter);
    _settingsChanged();
  }

  void removeNotification(NotificationHistory filter) {
    notificationHistoryList.remove(filter);
    _settingsChanged();
  }

  void removeAllNotifications() {
    notificationHistoryList.clear();
    _settingsChanged();
  }

  bool _pendingChanges = false;

  void _settingsChanged() async {
    if (!_isSettingsInitialized) {
      return;
    }
    while (_pendingChanges) {
      await Future.delayed(Duration(milliseconds: 100));
      // return;
    }

    _pendingChanges = true;
    notifyListeners();

    // TODO: Save notification settings here!
    // log("[Settings] Modified changes! Saving...");
    // await StorageRepository.saveSettings(settings: _toMap());

    _pendingChanges = false;
    notifyListeners();
  }
}
