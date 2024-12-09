import 'package:flutter/material.dart';

import 'option_item.dart';

class ListViewOptionItem extends StatelessWidget {
  const ListViewOptionItem({
    super.key,
    required this.title,
    this.description,
    this.leading,
    this.trailing,
    this.onClick,
    this.contentPadding = const EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
  });

  final String title;
  final String? description;
  final EdgeInsets contentPadding;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return OptionItem(
      title: title,
      paddingInside: contentPadding,
      description: description,
      leading: leading,
      trailing: trailing,
      onClick: onClick,
    );
  }
}
