import 'package:flutter/material.dart';

import 'base_view_model.dart';

class SettingsInstance extends ChangeNotifier with BaseViewModel {
  @override
  Future<void> initializing() async {}

  Locale locale = Locale("en");

  void setLocale(Locale lo) {
    locale = lo;
    notifyListeners();
  }
}
