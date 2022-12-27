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
    return MaterialApp(
      title: 'Subject Notifier',
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreenView(),
    );
  }
}
