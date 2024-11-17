import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({
    super.key,
    this.value = false,
    this.onPressed,
    required this.child,
    this.clipBehavior,
  });

  final bool value;
  final Function()? onPressed;
  final Widget child;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed?.call(),
      clipBehavior: clipBehavior,
      style: TextButton.styleFrom(
        backgroundColor: value ? Theme.of(context).buttonTheme.colorScheme?.secondaryContainer : null,
      ),
      child: child,
    );
  }
}
