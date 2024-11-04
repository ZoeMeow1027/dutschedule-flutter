mixin BaseViewModel {
  bool isInitialized = false;
  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    await initializing();

    isInitialized = true;
  }

  Future<void> initializing();
}