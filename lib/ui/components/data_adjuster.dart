import 'package:flutter/material.dart';

class DataAdjuster extends StatelessWidget {
  const DataAdjuster({
    super.key,
    required this.text,
    this.textStyle,
    this.leadingEnabled = true,
    this.trailingEnabled = true,
    this.leadingText = "<",
    this.trailingText = ">",
    this.onLeadingClicked,
    this.onTrailingClicked,
    this.width = double.infinity,
  });

  final String text;
  final double width;
  final TextStyle? textStyle;
  final bool leadingEnabled, trailingEnabled;
  final String leadingText, trailingText;
  final Function()? onLeadingClicked, onTrailingClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilledButton(
            onPressed: leadingEnabled ? onLeadingClicked : null,
            child: Text(
              leadingText,
              style: textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              text,
              style: textStyle,
            ),
          ),
          FilledButton(
            onPressed: trailingEnabled ? onTrailingClicked : null,
            child: Text(
              trailingText,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
