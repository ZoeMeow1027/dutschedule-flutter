import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_localizations.dart';
import '../../../utils/string_utils.dart';

class SubjectDetailInfo extends StatelessWidget {
  const SubjectDetailInfo({
    super.key,
    required this.subjectInfo,
    this.onClickAddToFilter,
  });

  final SubjectInformation subjectInfo;
  final Function()? onClickAddToFilter;

  @override
  Widget build(BuildContext context) {
    var dateStr = DateFormat("EEEE, dd/MM/yyyy HH:mm", Localizations.localeOf(context).toString()).format(
      DateTime.fromMillisecondsSinceEpoch(subjectInfo.subjectExam.date),
    );

    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "${subjectInfo.name}\n${subjectInfo.lecturerName}",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context).translateWithParameters("account_subjectinfo_data_id", [
                  StringUtils.formatString("{0}.{1}.{2}.{3}", [
                    subjectInfo.id.subjectId,
                    subjectInfo.id.schoolYearId,
                    subjectInfo.id.studentYearId,
                    subjectInfo.id.classId
                  ])
                ]),
              ),
              Text(
                AppLocalizations.of(context).translateWithParameters(
                  "account_subjectinfo_data_credit",
                  [subjectInfo.credit.toString()],
                ),
              ),
              Text(
                AppLocalizations.of(context).translateWithParameters(
                  "account_subjectinfo_data_ishighquality",
                  [subjectInfo.isHighQuality.toString()],
                ),
              ),
              Text(
                AppLocalizations.of(context).translateWithParameters(
                  "account_subjectinfo_data_scoreformula",
                  [subjectInfo.pointFormula],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Card.outlined(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("account_subjectinfo_data_schedulestudy_title"),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            AppLocalizations.of(context).translateWithParameters(
                              "account_subjectinfo_data_schedulestudy_dayofweek",
                              [
                                subjectInfo.subjectStudy.subjectStudyList
                                    .map((p) => "${p.dayOfWeek}-${p.lesson.toString()}-${p.room}")
                                    .join(", ")
                              ],
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).translateWithParameters(
                              "account_subjectinfo_data_schedulestudy_weekrange",
                              [subjectInfo.subjectStudy.weekList.map((p) => p.toString()).join(", ")],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Card.outlined(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("account_subjectinfo_data_scheduleexam_title"),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          AppLocalizations.of(context).translateWithParameters(
                            "account_subjectinfo_data_scheduleexam_group",
                            [
                              subjectInfo.subjectStudy.weekList.map((p) => p.toString()).join(", "),
                              subjectInfo.subjectExam.isGlobal
                                  ? AppLocalizations.of(context)
                                      .translate("account_subjectinfo_data_scheduleexam_groupglobal")
                                  : "",
                            ],
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translateWithParameters(
                            "account_subjectinfo_data_scheduleexam_date",
                            [dateStr],
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translateWithParameters(
                            "account_subjectinfo_data_scheduleexam_room",
                            [subjectInfo.subjectExam.room],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
