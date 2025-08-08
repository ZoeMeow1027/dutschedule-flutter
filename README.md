# DutSchedule
- An unofficial Android app to provide friendly UI from sv.dut.udn.vn.
- Continuing from [DutSchedule](https://github.com/ZoeMeow1027/DutSchedule), but written with Dart/Flutter.

## Version
- You're viewing v2.6.4+2508080000 (alpha)
  - Note that we will continue from old DutSchedule project, so we will use v2.0-alpha17 as beginning for now.
- Latest release version [![https://github.com/ZoeMeow1027/dutschedule_flutter](https://img.shields.io/github/v/release/ZoeMeow1027/dutschedule_flutter)](https://github.com/ZoeMeow1027/dutschedule_flutter/releases)
- [Entire source code changes](https://github.com/ZoeMeow1027/dutschedule_flutter/commits)
<!--[Summary change log](CHANGELOG.md) / -->

## Downloads
- Navigate to release (at right of this README) or click [here](https://github.com/ZoeMeow1027/dutschedule_flutter/releases) to download app.

## Features & screenshots?
- This isn't available right now. Please check later.

## FAQ

### Why some news in application is different from sv.dut.udn.vn?
- This app is only crawl data from sv.dut.udn.vn (web) and modify them for friendly view. To make sure you can read news cache when you are offline, app will need save current news and compare to web. So, news in app still there whenever news from web has been deleted.

### I need to clear old news. What should I do?
- You just need to refresh news and this will clear old and get latest one automatically.

### I'm got issue or a feature request about this library. What should I do?
- Check **known issues** below.

## Developing
- Requirements
  - You will need [Flutter v3.0 or later](https://flutter.dev/) (currently developed at v3.9)
  - An IDE or Text editor if you want to modify this project easier, for example:
    - [Visual Studio Code](https://code.visualstudio.com/) with [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) and [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) extension.
    - [Android Studio](https://developer.android.com/studio).
    - [IntelliJ IDEA Community](https://www.jetbrains.com/idea/).
  - If you got errors while building, you can try to clear package cache first by running command `dart pub cache clean`.
- Building/Running on CLI:
  - Just build or run with command `flutter build ...` or `flutter run` in your project directory. No extras arguments required. For more information, navigate to [Flutter document](https://docs.flutter.dev/).
  
## Known issues
- Background news task for fetching news on outside app doesn't work.
  - This will be solved in future releases.
- Notifications when outside app doesn't work.
  - This will be solved when `background news task` is ready to use.
- App background wallpaper doesn't work.
  - I will focus main task, plus it has difficult due to Android API changes by Google. [You can read here for why](https://github.com/ZoeMeow1027/DutSchedule/issues/19)
- If you find another issues or want to add a feature, navigate to [issue tab](https://github.com/ZoeMeow1027/dutschedule_flutter/issues) on this repository to create a issue or feature request.

## Credit and license?
- License: [**MIT**](LICENSE)
- DISCLAIMER:
  - This project - dutschedule_flutter - is not affiliated with [Da Nang University of Science and Technology school](https://dut.udn.vn).
  - DUT, Da Nang University of Technology, web materials and web contents are trademarks and copyrights of [Da Nang University of Science and Technology school](https://dut.udn.vn).
- References
  - https://github.com/flutter/flutter/issues/53229#issuecomment-1452057539
- All dependencies can be found at [pubspec.yaml](pubspec.yaml) file.
- Badge indicator powered by [shields.io](https://shields.io/)
