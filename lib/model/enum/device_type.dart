enum DeviceType {
  unknown(0),
  phone(1),
  tablet(2),
  largeTabletAndDesktop(3);

  final int value;
  const DeviceType(this.value);
}
