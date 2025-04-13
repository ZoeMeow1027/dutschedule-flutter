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

  NavigationDestination toNavDestination() {
    return NavigationDestination(
      icon: Icon(iconData),
      label: label,
    );
  }

  NavigationRailDestination toNavRailDestination() {
    return NavigationRailDestination(
      icon: Icon(iconData),
      label: Text(label),
      padding: EdgeInsets.symmetric(vertical: 4),
    );
  }
}

class ScaffoldNavigationList {
  ScaffoldNavigationList({this.itemList = const []});

  List<ScaffoldNavigationItem> itemList;

  List<NavigationDestination> toListNavDestinationList() {
    return itemList.map((e) => e.toNavDestination()).toList();
  }

  List<NavigationRailDestination> toNavRailDestinationList() {
    return itemList.map((e) => e.toNavRailDestination()).toList();
  }

  int get count {
    return itemList.length;
  }
}
