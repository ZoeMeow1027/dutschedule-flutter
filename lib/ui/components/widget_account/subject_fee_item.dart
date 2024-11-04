import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';

class SubjectFeeItem extends StatelessWidget {
  const SubjectFeeItem({
    super.key,
    required this.subjectFee,
    this.padding = EdgeInsets.zero,
    this.onClick,
  });

  final EdgeInsets padding;
  final SubjectFee subjectFee;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () {
          if (onClick != null) {
            onClick!();
          }
        },
        child: Card.filled(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      subjectFee.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Text("Credit(s): ${subjectFee.credit}, ${subjectFee.price} VND"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
