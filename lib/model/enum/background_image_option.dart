enum BackgroundImageOption {
  /// Don't use background image
  none(0),
  /// Use image from user desktop/launcher.
  currentWallpaper(1),
  /// Use image from user choice.
  yourPickedImage(2);

  final int value;
  const BackgroundImageOption(this.value);
}