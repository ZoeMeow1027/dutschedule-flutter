import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static void openSystemNotificationSettings() {
    if (Platform.isWindows) {
      launchUrl(Uri(scheme: "ms-settings", path: 'notifications'));
    }
  }
}
