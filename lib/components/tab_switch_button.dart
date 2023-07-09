import 'package:flutter/material.dart';

import '../utils/theme_tools.dart';

class TabSwitchButton extends StatelessWidget {
  const TabSwitchButton({
    super.key,
    required this.text,
    this.onClick,
    this.isFocus = false,
    this.padding = const EdgeInsets.all(0),
  });

  final String text;
  final EdgeInsetsGeometry padding;
  final Function()? onClick;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextButton(
        onPressed: () {
          if (onClick != null) {
            onClick!();
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: isFocus
            ? (ThemeTool.isDarkMode(context) ? Colors.white : Theme.of(context).primaryColor)
            : (ThemeTool.isDarkMode(context) ? Theme.of(context).primaryColor : Colors.white),
          foregroundColor: isFocus
            ? (ThemeTool.isDarkMode(context) ? Theme.of(context).primaryColor : Colors.white)
            : null,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: ThemeTool.isDarkMode(context) ? Colors.white : Theme.of(context).primaryColor,
              width: 1.5,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(text),
      )
    );
  }
}