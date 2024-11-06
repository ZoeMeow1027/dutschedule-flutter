import 'package:flutter/material.dart';

import '../../utils/theme_tools.dart';

class ListViewGroupItem extends StatelessWidget {
  const ListViewGroupItem({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.title,
    required this.children,
    this.dividerOnBottom = false,
  });

  final EdgeInsets padding;
  final String title;
  final List<Widget> children;
  final bool dividerOnBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          children.length + 2,
              (index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            } else if (index == children.length + 1) {
              return dividerOnBottom
                  ? Divider(
                color: ThemeTool.isAppDarkMode(context) ? Colors.white : Colors.black,
                thickness: 1,
                height: 0,
              )
                  : Container();
            } else {
              return children.elementAt(index - 1);
            }
          },
        ),
      ),
    );
  }
}
