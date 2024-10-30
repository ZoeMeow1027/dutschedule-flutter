import 'package:flutter/material.dart';

import 'get_device_type.dart';

extension BuildContextExtension on BuildContext {
  void clearSnackBars() {
    return ScaffoldMessenger.of(this).clearSnackBars();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar, {AnimationStyle? snackBarAnimationStyle}) {
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

  bool isDarkMode() {
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }
}
