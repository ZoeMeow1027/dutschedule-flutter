import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    this.padding = const EdgeInsets.only(),
    this.leadingIcon,
    required this.child,
    this.trailingIcon,
    this.backgroundColor,
    this.onClick,
  });

  factory MessageCard.info({
    EdgeInsets padding = const EdgeInsets.only(),
    required Widget child,
    Function()? onClick,
  }) =>
      MessageCard(
        padding: padding,
        leadingIcon: const Icon(Icons.info_outline, size: 32),
        trailingIcon: null,
        onClick: onClick,
        child: child,
      );

  factory MessageCard.warning({
    EdgeInsets padding = const EdgeInsets.only(),
    required Widget child,
    Function()? onClick,
  }) =>
      MessageCard(
        padding: padding,
        leadingIcon: Icon(
          Icons.warning_amber,
          size: 32,
          color: Colors.black,
        ),
        trailingIcon: null,
        onClick: onClick,
        backgroundColor: Colors.orange,
        child: child,
      );

  factory MessageCard.processing({
    EdgeInsets padding = const EdgeInsets.only(),
    required Widget child,
    Function()? onClick,
  }) =>
      MessageCard(
        padding: padding,
        leadingIcon: CircularProgressIndicator(),
        trailingIcon: null,
        onClick: onClick,
        child: child,
      );

  final EdgeInsets padding;
  final Widget? leadingIcon;
  final Widget child;
  final Widget? trailingIcon;
  final Function()? onClick;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: Card.filled(
        color: backgroundColor,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leadingIcon ?? Container(),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: leadingIcon != null ? 15 : 0,
                      right: trailingIcon != null ? 15 : 0,
                      top: 5,
                      bottom: 5,
                    ),
                    child: child,
                  ),
                ),
                trailingIcon ?? Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
