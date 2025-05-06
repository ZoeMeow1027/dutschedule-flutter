import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'repository/storage_repository.dart';
import 'ui/view_firstrun/getting_started_view.dart';
import 'ui/view_main/main_view.dart';
import 'utils/app_localizations.dart';
import 'utils/build_context_extension.dart';
import 'utils/custom_scroll_behavior.dart';
import 'viewmodel/account_session_instance.dart';
import 'viewmodel/news_cache_instance.dart';
import 'viewmodel/news_search_instance.dart';
import 'viewmodel/settings_instance.dart';

void main() async {
  // Initialize settings instance
  var settingsInstance = SettingsInstance.fromPreviousSettings(await StorageRepository.getPreviousSettings());
  // Initialize account session instance
  var accountSessionInstance = AccountSessionInstance.fromPreviousSettings(
    accountSessionJson: await StorageRepository.loadAccountSession(),
  );
  // Initialize news cache instance
  var newsCacheInstance = NewsCacheInstance();
  newsCacheInstance.timerInterval = settingsInstance.newsBackgroundDuration * 60 * 1000;
  // Initialize news search instance
  var newsSearchInstance = NewsSearchInstance.fromPreviousSettings(
    newsSearchJson: await StorageRepository.getNewsSearchHistory(),
  );

  // Ensure is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsInstance),
        ChangeNotifierProvider(create: (context) => newsCacheInstance),
        ChangeNotifierProvider(create: (context) => newsSearchInstance),
        ChangeNotifierProvider(create: (context) => accountSessionInstance),
      ],
      child: const MainApplication(),
    ),
  );
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          locale: settingsInstance.localeAuto ? null : settingsInstance.locale,
          title: "DutSchedule",
          scrollBehavior: CustomScrollBehavior(),
          theme: ThemeData(
            pageTransitionsTheme: _getPageTransitionsTheme(),
            primarySwatch: lightDynamic != null ? null : Colors.deepPurple,
            colorScheme: settingsInstance.followAccentColor
                ? lightDynamic
                : ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                  ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            pageTransitionsTheme: _getPageTransitionsTheme(),
            primarySwatch: darkDynamic != null ? null : Colors.deepPurple,
            colorScheme: settingsInstance.followAccentColor
                ? darkDynamic?.copyWith(surface: settingsInstance.blackBackground ? Colors.black : null)
                : ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: Brightness.dark,
                    surface: settingsInstance.blackBackground ? Colors.black : null,
                  ),
            useMaterial3: true,
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale("en"),
            const Locale("vi"),
          ],
          themeMode: settingsInstance.themeMode.toThemeMode(),
          home: PreloadApplication(),
        );
      },
    );
  }

  PageTransitionsTheme _getPageTransitionsTheme() {
    return PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }
}

class PreloadApplication extends StatefulWidget {
  const PreloadApplication({super.key});

  @override
  State<StatefulWidget> createState() => _PreloadApplication();
}

class _PreloadApplication extends State<PreloadApplication> {
  bool _isPreload = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _preloadData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);
    return settingsInstance.firstRunDone ? const MainScreenView() : const GettingStartedWelcome();
  }

  void _preloadData(BuildContext context) {
    // If is already preloaded, no more action needed.
    if (_isPreload) {
      return;
    }
    // Set to true to avoid another preload.
    setState(() {
      _isPreload = true;
    });

    // Preload news
    final newsCacheInstance = Provider.of<NewsCacheInstance>(context, listen: false);
    newsCacheInstance.fetchGlobalNews(
      fetchType: NewsFetchType.firstPage,
      onDone: (successful) {
        if (!successful) {
          // Notify error for user about unsuccessful preload news global.
          context.showCustomSnackBar(
            content: Text(AppLocalizations.of(context).translate("main_preload_preloadfailed_globalnews")),
            dismissOld: false,
          );
        }
      },
    );
    newsCacheInstance.fetchSubjectNews(
      fetchType: NewsFetchType.firstPage,
      onDone: (successful) {
        if (!successful) {
          // Notify error for user about unsuccessful preload news subject.
          context.showCustomSnackBar(
            content: Text(AppLocalizations.of(context).translate("main_preload_preloadfailed_subjectnews")),
            dismissOld: false,
          );
        }
      },
    );
    newsCacheInstance.fetchNewsStudentAffairs(
      fetchType: NewsFetchType.firstPage,
      onDone: (successful) {
        if (!successful) {
          // Notify error for user about unsuccessful preload news subject.
          context.showCustomSnackBar(
            // TODO: Change error text
            content: Text(AppLocalizations.of(context).translate("main_preload_preloadfailed_globalnews")),
            dismissOld: false,
          );
        }
      },
    );
    newsCacheInstance.fetchNewsExamination(
      fetchType: NewsFetchType.firstPage,
      onDone: (successful) {
        if (!successful) {
          // Notify error for user about unsuccessful preload news subject.
          context.showCustomSnackBar(
            // TODO: Change error text
            content: Text(AppLocalizations.of(context).translate("main_preload_preloadfailed_globalnews")),
            dismissOld: false,
          );
        }
      },
    );
    newsCacheInstance.fetchNewsTuitionFee(
      fetchType: NewsFetchType.firstPage,
      onDone: (successful) {
        if (!successful) {
          // Notify error for user about unsuccessful preload news subject.
          context.showCustomSnackBar(
            // TODO: Change error text
            content: Text(AppLocalizations.of(context).translate("main_preload_preloadfailed_globalnews")),
            dismissOld: false,
          );
        }
      },
    );

    // Preload account session
    final accountSessionInstance = Provider.of<AccountSessionInstance>(context, listen: false);
    // Preload account session - Login
    if (accountSessionInstance.authInfo != null) {
      accountSessionInstance.reLogin(
        forceRequest: true,
        afterRun: (successful) async {
          if (successful) {
            await accountSessionInstance.fetchStudentInformation(forceRequest: true);
          } else {
            await accountSessionInstance.login(
              authInfo: accountSessionInstance.authInfo,
              afterRun: (successful) async {
                if (successful) {
                  await accountSessionInstance.fetchStudentInformation(forceRequest: true);
                } else {
                  // Notify error for user about unsuccessful login.
                  context.showCustomSnackBar(
                    content: Text(AppLocalizations.of(context).translate("main_preload_preloadfailed_reloginaccount")),
                    dismissOld: false,
                  );
                }
              },
            );
          }
        },
      );
    }

    // final settingsInstance = Provider.of<SettingsInstance>(context);
  }
}
