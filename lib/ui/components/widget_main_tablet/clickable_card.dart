import 'package:flutter/material.dart';

class ClickableCardInfo extends StatelessWidget {
  const ClickableCardInfo({
    super.key,
    required this.title,
    this.leading,
    this.description,
    this.onClick,
  });

  final String title;
  final String? description;
  final Function()? onClick;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 60),
      child: Card.filled(
        child: InkWell(
          onTap: onClick,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 15),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.info),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      description != null ? Text(description!) : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
