import 'package:flutter/material.dart';

class ScaffoldNavigationItem {
  late String label;
  late IconData iconData;
  late int id;

  ScaffoldNavigationItem({
    required this.label,
    required this.iconData,
    this.id = 0,
  });

  NavigationDestination convertToNavDestination() {
    return NavigationDestination(
      icon: Icon(iconData),
      label: label,
    );
  }

  NavigationRailDestination convertToNavRailDestination() {
    return NavigationRailDestination(
      icon: Icon(iconData),
      label: Text(label),
    );
  }
}

class ScaffoldNavigationList {
  ScaffoldNavigationList({this.itemList = const []});

  List<ScaffoldNavigationItem> itemList;

  List<NavigationDestination> convertToListNavDestination() {
    return itemList.map((e) => e.convertToNavDestination()).toList();
  }

  List<NavigationRailDestination> convertToListNavRailDestination() {
    return itemList.map((e) => e.convertToNavRailDestination()).toList();
  }
}
