import 'package:flutter/material.dart';

class SwitchWithSurface extends StatelessWidget {
  const SwitchWithSurface({
    super.key,
    required this.title,
    this.value = false,
    this.width = double.infinity,
    this.height = 90,
    this.isEnabled = true,
    this.padding = EdgeInsets.zero,
    this.onClick,
  });

  final double width;
  final double height;
  final bool isEnabled;
  final bool value;
  final String title;
  final Function(bool)? onClick;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: isEnabled
            ? () {
                onClick?.call(!value);
              }
            : null,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: isEnabled
                ? Theme.of(context).buttonTheme.colorScheme?.onPrimary
                : Theme.of(context).buttonTheme.colorScheme?.onSecondary,
            borderRadius: BorderRadius.circular(30.0),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: (value) {
                    if (isEnabled) {
                      onClick?.call(!this.value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
