import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'screens/main_screen/main_screen_view.dart';
import 'utils/custom_scroll_behavior.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApplication());
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
          themeMode: ThemeMode.dark,
          home: const MainScreenView(),
        );
      },
    );
  }
}
