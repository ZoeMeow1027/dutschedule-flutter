import 'package:flutter/material.dart';

class WidgetVisible extends StatelessWidget {
  const WidgetVisible({
    super.key,
    this.isVisible = true,
    required this.child,
  });

  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return isVisible ? child : Container();
  }
}
