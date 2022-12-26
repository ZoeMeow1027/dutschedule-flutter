import 'package:flutter/material.dart';

import 'tabs_phone/news_page.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreenView> {
  int _selectedPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const NewsPage(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper),
            label: "News",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: "Account",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedIndex: _selectedPage,
        onDestinationSelected: (index) {
          setState(() => {_selectedPage = index});
        },
      ),
    );
  }
}
