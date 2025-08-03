import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/build_context_extension.dart';
import '../../../utils/string_utils.dart';

class SubjectInfoItem extends StatelessWidget {
  const SubjectInfoItem({
    super.key,
    required this.subjectInfo,
    this.padding = EdgeInsets.zero,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.onClick,
  });

  final EdgeInsets padding;
  final SubjectInformation subjectInfo;
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
                Text(
                  subjectInfo.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(StringUtils.formatString(
                  AppLocalizations.of(context).translate("account_subjectinfo_summary_schinfo"),
                  [
                    subjectInfo.lecturerName,
                    subjectInfo.subjectStudy.weekList.map((p) => p.toString()).toList().join(", "),
                    subjectInfo.subjectStudy.subjectStudyList.map((p) {
                      return StringUtils.formatString(
                        AppLocalizations.of(context).translate("account_subjectinfo_summary_schitem"),
                        [context.getDateOfWeekString(dayOfWeek: p.dayOfWeek), p.lesson.start.toString(), p.lesson.end.toString(), p.room,],
                      );
                    }).join("\n"),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
