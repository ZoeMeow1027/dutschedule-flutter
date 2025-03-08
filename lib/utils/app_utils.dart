import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static void openSystemNotificationSettings() {
    if (Platform.isWindows) {
      launchUrl(Uri(scheme: "ms-settings", path: 'notifications'));
    }
  }

  static void launchOwnUrl(
    String url, {
    Function()? onFailed,
  }) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } else {
      if (onFailed != null) {
        onFailed();
      }
    }
  }
}
