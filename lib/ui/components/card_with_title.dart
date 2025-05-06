import 'package:flutter/material.dart';

class CardWithTitle extends StatelessWidget {
  const CardWithTitle({
    super.key,
    required this.title,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.onClick,
  });

  final String title;
  final EdgeInsets padding;
  final Widget child;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card.filled(
        child: _main(context),
      ),
    );
  }

  Widget _main(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
