import 'package:flutter/material.dart';

import '../../utils/theme_tools.dart';

class TabSwitchButton extends StatelessWidget {
  const TabSwitchButton({
    super.key,
    required this.text,
    this.onClick,
    this.isVisible = true,
    this.isFocus = false,
    this.padding = const EdgeInsets.all(0),
  });

  final String text;
  final EdgeInsetsGeometry padding;
  final Function()? onClick;
  final bool isVisible;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    return !isVisible
        ? Center(
            widthFactor: 1,
            heightFactor: 1,
          )
        : Padding(
            padding: padding,
            child: TextButton(
              onPressed: () {
                if (onClick != null) {
                  onClick!();
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: isFocus
                    ? (ThemeTool.isAppDarkMode(context)
                        ? Colors.white
                        : Theme.of(context).primaryColor)
                    : (ThemeTool.isAppDarkMode(context)
                        ? Theme.of(context).primaryColor
                        : Colors.white),
                foregroundColor: isFocus
                    ? (ThemeTool.isAppDarkMode(context)
                        ? Theme.of(context).primaryColor
                        : Colors.white)
                    : null,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: ThemeTool.isAppDarkMode(context)
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(text),
            ));
  }
}
