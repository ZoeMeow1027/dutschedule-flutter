import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.title,
    this.paddingInside = EdgeInsets.zero,
    this.description,
    this.leading,
    this.trailing,
    this.color,
    this.onClick,
    this.roundSize = 0,
  });

  final Color? color;
  final EdgeInsets paddingInside;
  final String title;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onClick;
  final double roundSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () => onClick?.call(),
        child: Container(
          padding: paddingInside,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(roundSize),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading != null ? leading! : Container(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: leading != null ? 20 : 0,
                    right: trailing != null ? 15 : 0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (description != null) Text(description!),
                      // description != null ? Text(description!) : Container(),
                    ],
                  ),
                ),
              ),
              trailing != null ? trailing! : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
