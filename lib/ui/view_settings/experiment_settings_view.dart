import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/school_year.dart';
import '../../utils/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../../utils/theme_tools.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/data_adjuster.dart';
import '../components/list_view_option_item.dart';
import '../components/listview_group_item.dart';

class ExperimentSettingsView extends StatelessWidget {
  const ExperimentSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_experiment_title")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_experiment_category_globalvar"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_experiment_option_currentschyear"),
                  description: AppLocalizations.of(context).translateWithParameters(
                    "settings_experiment_option_currentschyear_description",
                    [
                      settingsInstance.currentSchoolYear.year.toString(),
                      (settingsInstance.currentSchoolYear.year + 1).toString(),
                      (settingsInstance.currentSchoolYear.semester > 2
                              ? 2
                              : settingsInstance.currentSchoolYear.semester)
                          .toString(),
                      settingsInstance.currentSchoolYear.semester != 3
                          ? ""
                          : AppLocalizations.of(context)
                              .translate("settings_experiment_option_currentschyear_insummer"),
                    ],
                  ),
                  onClick: () async {
                    // Get latest data from settings instance, because this settings will save after
                    // press 'Save' button only.
                    SchoolYear tempSchYear = SchoolYear(
                      year: settingsInstance.currentSchoolYear.year,
                      semester: settingsInstance.currentSchoolYear.semester,
                    );

                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context).translate("settings_dialog_schyear_title")),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Text(
                                      AppLocalizations.of(context).translate("settings_dialog_schyear_description"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: ThemeTool.isAppDarkMode(context) ? Colors.black45 : Colors.white60,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 7),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("settings_dialog_schyear_choice_schyear"),
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ),
                                          DataAdjuster(
                                            text: StringUtils.formatString(
                                              "20{0}-20{1}",
                                              [
                                                tempSchYear.year.toString().padLeft(2, '0'),
                                                (tempSchYear.year + 1).toString().padLeft(2, '0'),
                                              ],
                                            ),
                                            leadingEnabled: tempSchYear.year > 9,
                                            trailingEnabled: tempSchYear.year < 50,
                                            onLeadingClicked: () => setState(() {
                                              tempSchYear = SchoolYear(
                                                year: tempSchYear.year - 1,
                                                semester: tempSchYear.semester,
                                              );
                                            }),
                                            onTrailingClicked: () => setState(() {
                                              tempSchYear = SchoolYear(
                                                year: tempSchYear.year + 1,
                                                semester: tempSchYear.semester,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: ThemeTool.isAppDarkMode(context) ? Colors.black45 : Colors.white60,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 7),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate("settings_dialog_schyear_choice_semester"),
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ),
                                          DataAdjuster(
                                            text: StringUtils.formatString(
                                              "{0} {1} {2}",
                                              [
                                                AppLocalizations.of(context)
                                                    .translate("settings_dialog_schyear_choice_semester"),
                                                (tempSchYear.semester > 2 ? 2 : tempSchYear.semester).toString(),
                                                tempSchYear.semester <= 2
                                                    ? ""
                                                    : AppLocalizations.of(context)
                                                        .translate("settings_dialog_schyear_choice_insummer"),
                                              ],
                                            ),
                                            leadingEnabled: tempSchYear.semester > 1,
                                            trailingEnabled: tempSchYear.semester < 3,
                                            onLeadingClicked: () => setState(() {
                                              tempSchYear = SchoolYear(
                                                year: tempSchYear.year,
                                                semester: tempSchYear.semester - 1,
                                              );
                                            }),
                                            onTrailingClicked: () => setState(() {
                                              tempSchYear = SchoolYear(
                                                year: tempSchYear.year,
                                                semester: tempSchYear.semester + 1,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(AppLocalizations.of(context).translate("action_save")),
                                onPressed: () {
                                  Navigator.pop(context);
                                  settingsInstance.currentSchoolYear = SchoolYear(
                                    year: tempSchYear.year,
                                    semester: tempSchYear.semester,
                                  );
                                },
                              ),
                              TextButton(
                                child: Text(AppLocalizations.of(context).translate("action_cancel")),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_experiment_category_news"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_experiment_option_opennewsinpopup"),
                  description:
                      AppLocalizations.of(context).translate("settings_experiment_option_opennewsinpopup_description"),
                  trailing: Switch(
                    onChanged: (value) {
                      settingsInstance.openNewsInModalBottomSheet = value;
                    },
                    value: settingsInstance.openNewsInModalBottomSheet,
                  ),
                  onClick: () =>
                      settingsInstance.openNewsInModalBottomSheet = !settingsInstance.openNewsInModalBottomSheet,
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_experiment_category_troubleshooting"),
              dividerOnBottom: false,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_experiment_option_debuglog"),
                  description:
                      AppLocalizations.of(context).translate("settings_experiment_option_debuglog_description"),
                  onClick: () {
                    context.showCustomSnackBar(
                      content: Text(AppLocalizations.of(context).translate("feature_not_ready")),
                      dismissOld: true,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
