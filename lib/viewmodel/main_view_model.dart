import 'base_view_model.dart';

class MainViewModel extends BaseViewModel {
  @override
  void initializing() {}

  @override
  void timerAction() {}

  // Account page
  Map<String, Object> accountParameter = {};

  void setAccountValue(String key, Object value) {
    accountParameter[key] = value;
    notifyListeners();
  }
  // End account page
}
