import 'package:dutschedule/model/news_background_subject_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/list_view_option_item.dart';
import '../components/listview_group_item.dart';
import '../components/option_item.dart';
import '../components/switch_with_surface.dart';

class NewsNotificationsSettingsView extends StatelessWidget {
  const NewsNotificationsSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_newsnotify_title")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchWithSurface(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              title: AppLocalizations.of(context).translate("settings_newsnotify_fetchnewsinbackground"),
              value: settingsInstance.newsBackgroundDuration > 0,
              isEnabled: true,
              onClick: (changedValue) {
                if (changedValue) {
                  settingsInstance.newsBackgroundDuration = 60;
                } else {
                  settingsInstance.newsBackgroundDuration = 0;
                }
              },
            ),
            ListViewGroupItem(
              padding: EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_newsnotify_category_notification"),
              dividerOnBottom: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("settings_newsnotify_fetchnewsinbackground_duration"),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (settingsInstance.newsBackgroundDuration == 0)
                          Text(AppLocalizations.of(context)
                              .translate("settings_newsnotify_fetchnewsinbackground_value_disabled")),
                        if (settingsInstance.newsBackgroundDuration == 1)
                          Text(AppLocalizations.of(context)
                              .translate("settings_newsnotify_fetchnewsinbackground_value_enabled1")),
                        if (settingsInstance.newsBackgroundDuration > 1)
                          Text(AppLocalizations.of(context).translateWithParameters(
                            "settings_newsnotify_fetchnewsinbackground_value_enabled2",
                            [settingsInstance.newsBackgroundDuration.toString()],
                          )),
                        Slider(
                          value: settingsInstance.newsBackgroundDuration.toDouble(),
                          onChanged: (value) {
                            settingsInstance.newsBackgroundDuration = value.toInt();
                          },
                          onChangeEnd: (value) {
                            settingsInstance.newsBackgroundDuration = value.toInt();
                            // TODO: Save changes here!
                          },
                          min: 0,
                          max: 240,
                          divisions: 241,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 5,
                          runSpacing: 5,
                          children: <int>[15, 30, 60, 120, 240].map((duration) {
                            return ActionChip(
                              label: Text(AppLocalizations.of(context).translateWithParameters(
                                "settings_newsnotify_fetchnewsinbackground_option_value2",
                                [duration.toString()],
                              )),
                              onPressed: () {
                                settingsInstance.newsBackgroundDuration = duration;
                                // TODO: Save changes here!
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_newsnotify_newsglobal_title"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newsglobal_enable"),
                  leading: Checkbox(
                    value: settingsInstance.newsBackgroundGlobalEnabled,
                    onChanged: (value) {
                      settingsInstance.newsBackgroundGlobalEnabled = !settingsInstance.newsBackgroundGlobalEnabled;
                    },
                  ),
                  onClick: () {
                    settingsInstance.newsBackgroundGlobalEnabled = !settingsInstance.newsBackgroundGlobalEnabled;
                  },
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_title"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_disabled"),
                  leading: Radio(
                    value: NewsBackgroundSubjectType.none,
                    groupValue: settingsInstance.newsBackgroundSubjectEnabled,
                    onChanged: (value) {
                      settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.none;
                    },
                  ),
                  onClick: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.none;
                  },
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_all"),
                  leading: Radio(
                    value: NewsBackgroundSubjectType.allNews,
                    groupValue: settingsInstance.newsBackgroundSubjectEnabled,
                    onChanged: (value) {
                      settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.allNews;
                    },
                  ),
                  onClick: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.allNews;
                  },
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_matchsubsch"),
                  leading: Radio(
                    value: NewsBackgroundSubjectType.yourSchedule,
                    groupValue: settingsInstance.newsBackgroundSubjectEnabled,
                    onChanged: (value) {
                      settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.yourSchedule;
                    },
                  ),
                  onClick: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.yourSchedule;
                  },
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_matchfilter"),
                  leading: Radio(
                    value: NewsBackgroundSubjectType.yourFilterList,
                    groupValue: settingsInstance.newsBackgroundSubjectEnabled,
                    onChanged: (value) {
                      settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.yourFilterList;
                    },
                  ),
                  onClick: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.yourFilterList;
                  },
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_newsnotify_newsfilter_title"),
              dividerOnBottom: false,
              children: [
                if (settingsInstance.newsBackgroundSubjectEnabled != NewsBackgroundSubjectType.yourFilterList)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("settings_newsnotify_newsfilter_disabledwarning_title"),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate("settings_newsnotify_newsfilter_disabledwarning_description"),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 7),
                          child: Text(
                            AppLocalizations.of(context).translate("settings_newsnotify_newsfilter_list_title"),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (settingsInstance.newsBackgroundFilterList.isEmpty)
                          Text(
                            AppLocalizations.of(context).translate("settings_newsnotify_newsfilter_list_nofilters"),
                          ),
                        Column(
                          children: settingsInstance.newsBackgroundFilterList.map((filter) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: OptionItem(
                                roundSize: 10,
                                color: Theme.of(context).colorScheme.onPrimary,
                                paddingInside: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                title: StringUtils.formatString(
                                  "{0} - {1} - {2}",
                                  [filter.studentYearId, filter.classId, filter.subjectName],
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    // TODO: Show a message before deleting a item
                                    settingsInstance.removeNewsBackgroundFilter(filter);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: OptionItem(
                            roundSize: 10,
                            paddingInside: EdgeInsets.only(left: 10, right: 10, top: 10),
                            title: AppLocalizations.of(context).translate("settings_newsnotify_newsfilter_add"),
                            leading: Icon(Icons.add),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: OptionItem(
                            roundSize: 10,
                            paddingInside: EdgeInsets.only(left: 10, right: 10, top: 10),
                            title: AppLocalizations.of(context).translate("settings_newsnotify_newsfilter_deleteall"),
                            leading: Icon(Icons.delete),
                            onClick: () {
                              // TODO: Show a message before deleting all items
                              settingsInstance.removeAllNewsBackgroundFilters();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }
}
