import 'package:flutter/material.dart';

import 'views/news_page.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreenView> {
  int _selectedPage = 1;
  final _navDestList = const [
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
  ];

  final _navDestRailList = const [
    NavigationRailDestination(
      icon: Icon(Icons.home),
      label: Text("Home"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.newspaper),
      label: Text("News"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_circle_outlined),
      label: Text("Account"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text("Settings"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // 0: Phone
    // 1: Large screen phone
    // 2: Tablet/desktop
    final screenType = screenWidth <= 600
        ? 0
        : screenWidth <= 1000
            ? 1
            : 2;

    return Scaffold(
      body: Row(
        children: [
          screenType < 1
              ? const Center()
              : NavigationRail(
                  destinations: _navDestRailList,
                  selectedIndex: _selectedPage,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (index) {
                    setState(() => {_selectedPage = index});
                  },
                  minWidth: 80,
                ),
          Expanded(
            child: NewsPage(
              showDetailOnRight: screenType > 1,
            ),
          ),
        ],
      ),
      bottomNavigationBar: screenType < 1
          ? NavigationBar(
              destinations: _navDestList,
              selectedIndex: _selectedPage,
              onDestinationSelected: (index) {
                setState(() => {_selectedPage = index});
              },
            )
          : null,
    );
  }
}
