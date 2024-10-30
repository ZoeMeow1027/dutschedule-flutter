import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/main/main_view.dart';
import 'utils/custom_scroll_behavior.dart';
import 'viewmodel/account_session_instance.dart';
import 'viewmodel/main_viewmodel.dart';
import 'viewmodel/news_cache_instance.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainViewModel()),
        ChangeNotifierProvider(create: (context) => NewsCacheInstance()),
        ChangeNotifierProvider(create: (context) => AccountSessionInstance()),
      ],
      child: const MainApplication(),
    ),
  );
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'DutSchedule',
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
          themeMode: ThemeMode.system,
          home: const MainScreenView(),
        );
      },
    );
  }
}
