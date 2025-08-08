import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../background/bg_core.dart';
import '../../l10n/app_localizations.dart';
import '../../model/background_subject_code.dart';
import '../../model/enum/news_background_subject_type.dart';
import '../../utils/build_context_extension.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/news_cache_instance_v2.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/menu_list_group.dart';
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

  late int newsBackgroundDuration;

  @override
  void initState() {
    super.initState();
    final settingsInstance = Provider.of<SettingsInstance>(context, listen: false);
    newsBackgroundDuration = settingsInstance.newsBackgroundDuration;
  }

  @override
  Widget build(BuildContext context) {
    final newsCacheInstance = Provider.of<NewsCacheInstanceV2>(context);
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_newsnotify_title")),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchWithSurface(
              padding: EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_newsnotify_fetchnewsinbackground"),
              value: settingsInstance.newsBackgroundDuration > 0,
              isEnabled: true,
              onClick: (changedValue) {
                setState(() {
                  newsBackgroundDuration = changedValue ? 60 : 0;
                });
                settingsInstance.newsBackgroundDuration = newsBackgroundDuration;
                BackgroundTask.scheduleNewsBackgroundTaskOnDesktop(
                  newsCacheInstance: newsCacheInstance,
                  settingsInstance: settingsInstance,
                );
              },
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                AppLocalizations.of(context).translate("settings_newsnotify_category_backgroundrefreshduration"),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme?.secondaryContainer,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate("settings_newsnotify_fetchnewsinbackground_duration"),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    switch (newsBackgroundDuration) {
                      <= 0 => Text(AppLocalizations.of(context)
                          .translate("settings_newsnotify_fetchnewsinbackground_value_disabled")),
                      1 => Text(AppLocalizations.of(context)
                          .translate("settings_newsnotify_fetchnewsinbackground_value_enabled1")),
                      _ => Text(AppLocalizations.of(context).translateWithParameters(
                        "settings_newsnotify_fetchnewsinbackground_value_enabled2",
                        [newsBackgroundDuration.toString()],
                      )),
                    },
                    Slider(
                      value: (newsBackgroundDuration - 5 < 0 ? 0 : newsBackgroundDuration - 5).toDouble(),
                      onChanged: (value) {
                        setState(() {
                          newsBackgroundDuration = (value + 5).toInt();
                        });
                        // settingsInstance.newsBackgroundDuration = (value + 5).toInt();
                      },
                      onChangeEnd: (value) {
                        settingsInstance.newsBackgroundDuration = newsBackgroundDuration;
                        BackgroundTask.scheduleNewsBackgroundTaskOnDesktop(
                          newsCacheInstance: newsCacheInstance,
                          settingsInstance: settingsInstance,
                        );
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
                            setState(() {
                              newsBackgroundDuration = duration;
                            });
                            settingsInstance.newsBackgroundDuration = newsBackgroundDuration;
                            BackgroundTask.scheduleNewsBackgroundTaskOnDesktop(
                              newsCacheInstance: newsCacheInstance,
                              settingsInstance: settingsInstance,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            MenuListGroup(
              groupTitle: AppLocalizations.of(context).translate("settings_newsnotify_newsglobal_title"),
              itemMinHeight: 50,
              itemList: [
                MenuListGroupItem.checkboxButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newsglobal_enable"),
                  switchValue: settingsInstance.newsBackgroundGlobalEnabled,
                  onSwitchChanged: (newValue) => settingsInstance.newsBackgroundGlobalEnabled = newValue,
                  wrapTextWhenOverFlow: true,
                ),
                MenuListGroupItem.checkboxButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newsstudentaffairs_enable"),
                  switchValue: settingsInstance.newsBackgroundStudentAffairsEnabled,
                  onSwitchChanged: (newValue) => settingsInstance.newsBackgroundStudentAffairsEnabled = newValue,
                  wrapTextWhenOverFlow: true,
                ),
                MenuListGroupItem.checkboxButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newsexamination_enable"),
                  switchValue: settingsInstance.newsBackgroundExaminationEnabled,
                  onSwitchChanged: (newValue) => settingsInstance.newsBackgroundExaminationEnabled = newValue,
                  wrapTextWhenOverFlow: true,
                ),
                MenuListGroupItem.checkboxButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newstuition_enable"),
                  switchValue: settingsInstance.newsBackgroundTuitionFeeEnabled,
                  onSwitchChanged: (newValue) => settingsInstance.newsBackgroundTuitionFeeEnabled = newValue,
                  wrapTextWhenOverFlow: true,
                ),
                MenuListGroupItem.checkboxButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newsstatuteregulation_enable"),
                  switchValue: settingsInstance.newsBackgroundStatuteRegulationEnabled,
                  onSwitchChanged: (newValue) => settingsInstance.newsBackgroundStatuteRegulationEnabled = newValue,
                  wrapTextWhenOverFlow: true,
                ),
              ],
            ),
            SizedBox(height: 15),
            MenuListGroup(
              groupTitle: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_title"),
              itemMinHeight: 50,
              itemList: [
                MenuListGroupItem.radioButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_disabled"),
                  currentValue: settingsInstance.newsBackgroundSubjectEnabled,
                  radioValue: NewsBackgroundSubjectType.none,
                  onRadioClicked: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.none;
                  },
                ),
                MenuListGroupItem.radioButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_all"),
                  currentValue: settingsInstance.newsBackgroundSubjectEnabled,
                  radioValue: NewsBackgroundSubjectType.allNews,
                  onRadioClicked: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.allNews;
                  },
                ),
                MenuListGroupItem.radioButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_matchsubsch"),
                  currentValue: settingsInstance.newsBackgroundSubjectEnabled,
                  radioValue: NewsBackgroundSubjectType.yourSchedule,
                  onRadioClicked: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.yourSchedule;
                  },
                ),
                MenuListGroupItem.radioButton(
                  title: AppLocalizations.of(context).translate("settings_newsnotify_newssubject_matchfilter"),
                  currentValue: settingsInstance.newsBackgroundSubjectEnabled,
                  radioValue: NewsBackgroundSubjectType.yourFilterList,
                  onRadioClicked: () {
                    settingsInstance.newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.yourFilterList;
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                AppLocalizations.of(context).translate("settings_newsnotify_newsfilter_title"),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            if (settingsInstance.newsBackgroundSubjectEnabled != NewsBackgroundSubjectType.yourFilterList)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonTheme.colorScheme?.secondaryContainer,
                    borderRadius: BorderRadius.circular(20.0),
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
              padding: const EdgeInsets.only(),
              child: Container(
                // width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme?.secondaryContainer,
                  borderRadius: BorderRadius.circular(20.0),
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
                    MenuListGroup(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      itemMinHeight: 40,
                      itemList: List.generate(
                        settingsInstance.newsBackgroundFilterList.length,
                        (index) {
                          final filter = settingsInstance.newsBackgroundFilterList.elementAt(index);
                          return MenuListGroupItem(
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
                          );
                        },
                      ),
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
            Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ),
    );
  }
}
