import 'dart:developer';
import 'dart:io';

import 'package:dutwrapper/news_object.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/enum/app_log_level.dart';
import 'string_utils.dart';

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

  static void showLogToDebug({
    int? dateCreated,

    /// VERBOSE = 0, DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4
    required AppLogLevel resultTag,
    required String tag,
    String? subTag,
    required String message,
  }) {
    dateCreated ??= DateTime.now().toUtc().millisecondsSinceEpoch;

    log(StringUtils.formatString(
      '[{0}] [{1}] [{2}{3}] {4}',
      [
        DateFormat("yyyy/MM/dd HH:mm:ss.SSS")
            .format(DateTime.fromMillisecondsSinceEpoch(dateCreated, isUtc: true).toLocal()),
        resultTag.toString(),
        tag,
        subTag == null ? "" : StringUtils.formatString(' - {0}', [subTag]),
        message,
      ],
    ));
  }

  static bool isNewsEqual(NewsCore n1, NewsCore n2) {
    return (n1.title.compareTo(n2.title) == 0) &&
        (n1.datePublished == n2.datePublished) &&
        (n1.contentHtml.compareTo(n2.contentHtml) == 0);
  }
}