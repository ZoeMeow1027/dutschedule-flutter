import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:system_tray/system_tray.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import '../global_variables.dart';
import 'string_utils.dart';

class AppUtils {
  static Future<void> checkIfAnotherInstanceIsRunning() async {}

  static Future<void> hideWindowAtLaunch() async {
    await windowManager.ensureInitialized();

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.waitUntilReadyToShow(null, () async {
        await windowManager.hide(); // Hide on launch
      });
    }
  }

  static Future<void> distroyAndCreateNewSystemTray() async {
    // Replace with your own icon path
    String path = Platform.isWindows ? 'assets/app_icon_256.ico' : 'assets/app_icon_512.png';

    final AppWindow appWindow = AppWindow();
    final SystemTray systemTray = SystemTray();

    await systemTray.destroy();

    // We first init the systray menu
    await systemTray.initSystemTray(
      title: GlobalVariables.appDisplayName,
      toolTip: GlobalVariables.appDisplayName,
      iconPath: path,
    );

    // create context menu
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
      MenuSeparator(),
      MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
    ]);

    // set context menu
    await systemTray.setContextMenu(menu);

    // handle system tray event
    systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
      }
    });
  }

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
        DateFormat("yyyy/MM/dd HH:mm:ss")
            .format(DateTime.fromMillisecondsSinceEpoch(dateCreated, isUtc: true).toLocal()),
        switch (resultTag.value) {
          0 => "VERBOSE",
          1 => "DEBUG",
          2 => "INFO",
          3 => "WARN",
          4 => "ERROR",
          _ => "_",
        },
        tag,
        subTag == null ? "" : StringUtils.formatString(' - {0}', [subTag]),
        message,
      ],
    ));
  }
}

enum AppLogLevel {
  error(4),
  warning(3),
  info(2),
  debug(1),
  verbose(0);

  final int value;
  const AppLogLevel(this.value);
}
