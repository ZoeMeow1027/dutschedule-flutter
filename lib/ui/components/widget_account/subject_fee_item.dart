import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../../utils/string_utils.dart';

class SubjectFeeItem extends StatelessWidget {
  const SubjectFeeItem({
    super.key,
    required this.subjectFee,
    this.padding = EdgeInsets.zero,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.onClick,
  });

  final EdgeInsets padding;
  final SubjectFee subjectFee;
  final Function()? onClick;
  final bool shouldRadiusOnTop;
  final bool shouldRadiusOnBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(shouldRadiusOnTop ? 20 : 5),
          topLeft: Radius.circular(shouldRadiusOnTop ? 20 : 5),
          bottomLeft: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
          bottomRight: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
        ),
        child: InkWell(
          onTap: () {
            if (onClick != null) {
              onClick!();
            }
          },
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
                Text(StringUtils.formatString(
                  AppLocalizations.of(context).translate("account_subjectfee_summary_main"),
                  [subjectFee.credit.toString(), subjectFee.price.toStringAsFixed(0)],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
