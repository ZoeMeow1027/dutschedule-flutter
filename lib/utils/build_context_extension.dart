import 'package:flutter/material.dart';

import 'get_device_type.dart';

extension BuildContextExtension on BuildContext {
  void clearSnackBars() {
    return ScaffoldMessenger.of(this).clearSnackBars();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar({
    required Widget content,
    AnimationStyle? snackBarAnimationStyle,
    bool dismissOld = true,
  }) {
    if (dismissOld) {
      clearSnackBars();
    }
    return showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: content,
      ),
      snackBarAnimationStyle: snackBarAnimationStyle,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar,
      {AnimationStyle? snackBarAnimationStyle}) {
    return ScaffoldMessenger.of(this).showSnackBar(snackBar, snackBarAnimationStyle: snackBarAnimationStyle);
  }

  DeviceType getDeviceType() {
    final screenWidth = MediaQuery.of(this).size.width;

    return screenWidth <= 600
        ? DeviceType.phone
        : screenWidth <= 1000
            ? DeviceType.tablet
            : DeviceType.largeTabletAndDesktop;
  }

  bool isAppDarkMode() {
    return Theme.of(this).brightness == Brightness.dark;
  }

  bool isOSDarkMode() {
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }

  String getDurationFromCurrent(DateTime dateTime) {
    final current = DateTime.now().toUtc();
    final duration = current.millisecondsSinceEpoch - dateTime.toUtc().millisecondsSinceEpoch;
    final durationSeconds = duration / 1000;
    int second = (durationSeconds % 60).toInt();
    int minute = ((durationSeconds / 60) % 60).toInt();
    int hour = ((durationSeconds / (60 * 60)) % 24).toInt();
    int day = ((durationSeconds / (60 * 60 * 24)) % 30).toInt();
    int week = ((durationSeconds / (60 * 60 * 24 * 7)) % 30).toInt();
    int month = ((durationSeconds / (60 * 60 * 24 * 30)) % 12).toInt();
    int year = (durationSeconds / (60 * 60 * 24 * 365)).toInt();

    if (year > 0) {
      return switch (year == 1) {
        true => '$year year ago',
        false => '$year years ago',
      };
    } else if (month > 0) {
      return switch (month == 1) {
        true => '$month month ago',
        false => '$month months ago',
      };
    } else if (week > 0 && week < 5) {
      return switch (week == 1) {
        true => '$week week ago',
        false => '$week weeks ago',
      };
    } else if (day > 0) {
      return switch (day == 1) {
        true => '$day day ago',
        false => '$day days ago',
      };
    } else if (hour > 0) {
      return switch (hour == 1) {
        true => '$hour hour ago',
        false => '$hour hours ago',
      };
    } else if (minute > 0) {
      return switch (minute == 1) {
        true => '$minute minute ago',
        false => '$minute minutes ago',
      };
    } else {
      return switch (second == 1) {
        true => '$second second ago',
        false => '$second seconds ago',
      };
    }
  }
}
