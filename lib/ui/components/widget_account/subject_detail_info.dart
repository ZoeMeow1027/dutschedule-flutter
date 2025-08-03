import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/build_context_extension.dart';
import '../../../utils/string_utils.dart';

class SubjectDetailInfo extends StatelessWidget {
  const SubjectDetailInfo({
    super.key,
    required this.subjectInfo,
    this.onClickAddToFilter,
    this.onAddToFilter,
  });

  final SubjectInformation subjectInfo;
  final Function()? onClickAddToFilter;
  final Function()? onAddToFilter;

  @override
  Widget build(BuildContext context) {
    var dateStr = DateFormat("EEEE, dd/MM/yyyy HH:mm", Localizations.localeOf(context).toString()).format(
      DateTime.fromMillisecondsSinceEpoch(subjectInfo.subjectExam.date),
    );

    return FractionallySizedBox(
      heightFactor: 0.75,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
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
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("account_subjectinfo_data_schedulestudy_title"),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).translateWithParameters(
                                  "account_subjectinfo_data_schedulestudy_dayofweek",
                                  [
                                    subjectInfo.subjectStudy.subjectStudyList
                                        .map((p) =>
                                            "- ${context.getDateOfWeekString(dayOfWeek: p.dayOfWeek)}, ${p.lesson.toString()}, ${p.room}")
                                        .join("\n")
                                  ],
                                ),
                              ),
                              Text(''),
                              Text(
                                AppLocalizations.of(context).translateWithParameters(
                                  "account_subjectinfo_data_schedulestudy_weekrange",
                                  [subjectInfo.subjectStudy.weekList.map((p) => '- ${p.toString()}').join("\n")],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  AppLocalizations.of(context).translate("account_subjectinfo_data_scheduleexam_title"),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).translateWithParameters(
                                  "account_subjectinfo_data_scheduleexam_group",
                                  [
                                    subjectInfo.subjectExam.group,
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
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: onAddToFilter,
                  icon: Icon(Icons.add),
                  label: Text("Add to filter"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
