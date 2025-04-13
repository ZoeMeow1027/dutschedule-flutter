import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/background_subject_code.dart';
import '../../model/news_background_subject_type.dart';
import '../../utils/app_localizations.dart';
import '../../utils/build_context_extension.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/news_cache_instance.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/list_view_option_item.dart';
import '../components/listview_group_item.dart';
import '../components/option_item.dart';
import '../components/switch_with_surface.dart';

class NewsNotificationsSettingsView extends StatefulWidget {
  const NewsNotificationsSettingsView({super.key});

  @override
  State<StatefulWidget> createState() => _NewsNotificationsSettingsView();
}

class _NewsNotificationsSettingsView extends State<NewsNotificationsSettingsView> {
  final _tfSchoolYearId = TextEditingController();
  final _tfClassId = TextEditingController();
  final _tfSubjectName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newsCacheInstance = Provider.of<NewsCacheInstance>(context);
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
                  newsCacheInstance.timerInterval = 60 * 60 * 1000;
                  newsCacheInstance.startTimer(startOver: true);
                } else {
                  newsCacheInstance.stopTimer();
                  newsCacheInstance.timerInterval = 0 * 60 * 1000;
                  settingsInstance.newsBackgroundDuration = 0;
                }
              },
            ),
            ListViewGroupItem(
              padding: EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_newsnotify_category_backgroundrefreshduration"),
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
                          value: (settingsInstance.newsBackgroundDuration - 5 < 0
                                  ? 0
                                  : settingsInstance.newsBackgroundDuration - 5)
                              .toDouble(),
                          onChanged: (value) {
                            settingsInstance.newsBackgroundDuration = (value + 5).toInt();
                          },
                          onChangeEnd: (value) {
                            settingsInstance.newsBackgroundDuration = (value + 5).toInt();
                            newsCacheInstance.timerInterval = (value + 5).toInt() * 60 * 1000;
                            newsCacheInstance.startTimer(startOver: true);
                          },
                          min: 0,
                          max: 235,
                          divisions: 236,
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
                                newsCacheInstance.timerInterval = 1000 * 60 * duration;
                                settingsInstance.newsBackgroundDuration = duration;
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
                    // width: double.infinity,
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
                                  "{2} [{0}.Nh{1}]",
                                  [filter.studentYearId, filter.classId, filter.subjectName],
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    // Show a message before deleting a item
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Text(AppLocalizations.of(context)
                                            .translate("settings_newsnotify_newsfilter_dialogdelete_title")),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            spacing: 8,
                                            children: [
                                              Text(AppLocalizations.of(context).translateWithParameters(
                                                "settings_newsnotify_newsfilter_dialogdelete_description",
                                                [filter.subjectName, filter.studentYearId, filter.classId],
                                              )),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(AppLocalizations.of(context)
                                                .translate("settings_newsnotify_newsfilter_dialogdelete_yes")),
                                            onPressed: () {
                                              try {
                                                // Delete an item here!
                                                var temp = BackgroundSubjectCode.fromJson(filter.toJson());
                                                settingsInstance.removeNewsBackgroundFilter(filter);
                                                context.showCustomSnackBar(
                                                  content: Text(AppLocalizations.of(context).translateWithParameters(
                                                    "settings_newsnotify_newsfilter_notify_delete",
                                                    [temp.subjectName, temp.studentYearId, temp.classId],
                                                  )),
                                                  dismissOld: true,
                                                );
                                              } catch (ex) {
                                                // TODO: Notify user error here.
                                                // context.showCustomSnackBar(
                                                //   content: Text(AppLocalizations.of(context).translate("link_failed")),
                                                //   dismissOld: true,
                                                // );
                                              } finally {
                                                // Dialog must be closed with any reason.
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: Text(AppLocalizations.of(context)
                                                .translate("settings_newsnotify_newsfilter_dialogdelete_no")),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
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
                            onClick: () {
                              // Clear all text in 3 text editing controller before showing dialog.
                              _tfSchoolYearId.clear();
                              _tfClassId.clear();
                              _tfSubjectName.clear();
                              // Show dialog as usual.
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(AppLocalizations.of(context)
                                      .translate("settings_newsnotify_newsfilter_dialogadd_title")),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      spacing: 8,
                                      children: [
                                        Text(AppLocalizations.of(context)
                                            .translate("settings_newsnotify_newsfilter_dialogadd_description")),
                                        TextField(
                                          controller: _tfSchoolYearId,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: AppLocalizations.of(context)
                                                .translate("settings_newsnotify_newsfilter_dialogadd_schyear"),
                                          ),
                                        ),
                                        TextField(
                                          controller: _tfClassId,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: AppLocalizations.of(context)
                                                .translate("settings_newsnotify_newsfilter_dialogadd_class"),
                                          ),
                                        ),
                                        TextField(
                                          controller: _tfSubjectName,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: AppLocalizations.of(context)
                                                .translate("settings_newsnotify_newsfilter_dialogadd_schname"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate("action_ok")),
                                      onPressed: () {
                                        try {
                                          // Add an item here! If successful, dialog will disappear.
                                          settingsInstance.addNewsBackgroundFilter(BackgroundSubjectCode(
                                            studentYearId: _tfSchoolYearId.text,
                                            classId: _tfClassId.text,
                                            subjectName: _tfSubjectName.text,
                                          ));
                                          context.showCustomSnackBar(
                                            content: Text(AppLocalizations.of(context).translateWithParameters(
                                              "settings_newsnotify_newsfilter_notify_add",
                                              [
                                                _tfSubjectName.text,
                                                _tfSchoolYearId.text,
                                                _tfClassId.text,
                                              ],
                                            )),
                                            dismissOld: true,
                                          );
                                          Navigator.pop(context);
                                        } catch (ex) {
                                          // TODO: Notify user error here.
                                          // context.showCustomSnackBar(
                                          //   content: Text(AppLocalizations.of(context).translate("link_failed")),
                                          //   dismissOld: true,
                                          // );
                                        }
                                      },
                                    ),
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate("action_cancel")),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            },
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
                              // Show a message before deleting all items
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(AppLocalizations.of(context)
                                      .translate("settings_newsnotify_newsfilter_dialogdeleteall_title")),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      spacing: 8,
                                      children: [
                                        Text(AppLocalizations.of(context)
                                            .translate("settings_newsnotify_newsfilter_dialogdeleteall_description")),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(AppLocalizations.of(context)
                                          .translate("settings_newsnotify_newsfilter_dialogdelete_yes")),
                                      onPressed: () {
                                        try {
                                          // Clear all subject filter here!
                                          settingsInstance.removeAllNewsBackgroundFilters();
                                          context.showCustomSnackBar(
                                            content: Text(AppLocalizations.of(context)
                                                .translate("settings_newsnotify_newsfilter_notify_deleteall")),
                                            dismissOld: true,
                                          );
                                        } catch (ex) {
                                          // TODO: Notify user error here.
                                          // context.showCustomSnackBar(
                                          //   content: Text(AppLocalizations.of(context).translate("link_failed")),
                                          //   dismissOld: true,
                                          // );
                                        } finally {
                                          // Dialog must be closed with any reason.
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                    TextButton(
                                      child: Text(AppLocalizations.of(context)
                                          .translate("settings_newsnotify_newsfilter_dialogdelete_no")),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
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
