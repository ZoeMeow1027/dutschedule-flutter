// https://tech-lead.medium.com/advanced-enums-in-flutter-a8f2e2702ffd

import 'package:flutter/material.dart';

enum DeviceType {
  unknown(0),
  phone(1),
  tablet(2),
  largeTabletAndDesktop(3);

  final int value;

  const DeviceType(this.value);
}

DeviceType getDeviceType(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return screenWidth <= 600
      ? DeviceType.phone
      : screenWidth <= 1000
          ? DeviceType.tablet
          : DeviceType.largeTabletAndDesktop;
}
