// https://tech-lead.medium.com/advanced-enums-in-flutter-a8f2e2702ffd


enum DeviceType {
  unknown(0),
  phone(1),
  tablet(2),
  largeTabletAndDesktop(3);

  final int value;

  const DeviceType(this.value);
}
