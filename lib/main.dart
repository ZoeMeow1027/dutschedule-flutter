import 'package:dutschedule/viewmodel/settings_instance.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'ui/view_main/main_view.dart';
import 'utils/app_localizations.dart';
import 'utils/custom_scroll_behavior.dart';
import 'viewmodel/account_session_instance.dart';
import 'viewmodel/main_view_model.dart';
import 'viewmodel/news_cache_instance.dart';
import 'viewmodel/news_search_instance.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsInstance()),
        ChangeNotifierProvider(create: (context) => MainViewModel()),
        ChangeNotifierProvider(create: (context) => NewsCacheInstance()),
        ChangeNotifierProvider(create: (context) => NewsSearchInstance()),
        ChangeNotifierProvider(create: (context) => AccountSessionInstance()),
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
            primarySwatch: lightDynamic != null ? null : Colors.blue,
            colorScheme: lightDynamic,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            primarySwatch: darkDynamic != null ? null : Colors.blue,
            colorScheme: darkDynamic,
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
          themeMode: settingsInstance.themeMode,
          home: const MainScreenView(),
        );
      },
    );
  }
}
