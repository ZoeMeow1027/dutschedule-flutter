import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global_variables.dart';
import '../../model/enum/app_theme_mode.dart';
import '../../model/enum/background_image_option.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_utils.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/menu_list_group.dart';
import '../components/widget_settings/theme_mode_dialog.dart';
import 'about_view.dart';
import 'experiment_settings_view.dart';
import 'languages_view.dart';
import 'network_check_view.dart';
import 'news_notifications_settings_view.dart';
import 'parse_news_subject_notifications_view.dart';
import 'wallpaper_and_style_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_title")),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            MenuListGroup(
              groupTitle: AppLocalizations.of(context).translate("settings_category_notifications"),
              itemList: [
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_newsschedule"),
                  description: AppLocalizations.of(context).translate("settings_option_newsschedule_description"),
                  leading: Icon(Icons.calendar_month),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsNotificationsSettingsView(),
                    ),
                  ),
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_parsenewssubject_title"),
                  description: settingsInstance.newsBackgroundParseNewsSubject
                      ? AppLocalizations.of(context).translate("settings_newsnotify_parsenewssubject_enabled")
                      : AppLocalizations.of(context).translate("settings_newsnotify_parsenewssubject_disabled"),
                  leading: Icon(Icons.calendar_month),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParseNewsSubjectNotificationsView(),
                    ),
                  ),
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_notificationoutside"),
                  description:
                      AppLocalizations.of(context).translate("settings_option_notificationoutside_description"),
                  leading: Icon(Icons.notifications),
                  onClick: () {
                    AppUtils.openSystemNotificationSettings();
                  },
                ),
                // TODO: Developing do not distrub from time
                MenuListGroupItem(
                  title: "Do not distrub",
                  description: "This feature will prevent notify you from specific time range you chosen."
                      "\n(This feature is developing. Check back soon)",
                  leading: Icon(Icons.do_not_disturb),
                  onClick: () {},
                ),
              ],
            ),
            SizedBox(height: 15),
            MenuListGroup(
              groupTitle: AppLocalizations.of(context).translate("settings_category_appearance"),
              itemList: [
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_apptheme"),
                  description: StringUtils.formatString("{0} {1}", [
                    settingsInstance.themeMode == AppThemeMode.followSystemSettings
                        ? AppLocalizations.of(context).translate("settings_option_apptheme_choice_followdevice")
                        : settingsInstance.themeMode == AppThemeMode.lightMode
                            ? AppLocalizations.of(context).translate("settings_option_apptheme_choice_light")
                            : AppLocalizations.of(context).translate("settings_option_apptheme_choice_dark"),
                    settingsInstance.followAccentColor
                        ? AppLocalizations.of(context).translate("settings_option_apptheme_choice_dynamiccolorenabled")
                        : ""
                  ]),
                  leading: Icon(Icons.color_lens),
                  onClick: () async => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => ThemeModeDialog(
                      selectedMode: settingsInstance.themeMode,
                      onSelectModeChanged: (value) {
                        settingsInstance.themeMode = value;
                      },
                      accentColor: settingsInstance.followAccentColor,
                      onAccentColorModeChanged: (value) {
                        settingsInstance.followAccentColor = value;
                      },
                    ),
                  ),
                ),
                MenuListGroupItem.toggleButton(
                  title: AppLocalizations.of(context).translate("settings_option_blackbackground"),
                  description: AppLocalizations.of(context).translate("settings_option_blackbackground_description"),
                  leading: Icon(Icons.contrast),
                  switchValue: settingsInstance.blackBackground,
                  onSwitchChanged: (newValue) => settingsInstance.blackBackground = newValue,
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_wallpaperbackground"),
                  description: StringUtils.formatString("{0}", [
                    settingsInstance.backgroundImageOption == BackgroundImageOption.none
                        ? AppLocalizations.of(context).translate("settings_option_wallpaperbackground_choice_none")
                        : settingsInstance.backgroundImageOption == BackgroundImageOption.currentWallpaper
                            ? AppLocalizations.of(context)
                                .translate("settings_option_wallpaperbackground_choice_currentwallpaper")
                            : AppLocalizations.of(context)
                                .translate("settings_option_wallpaperbackground_choice_pickedimage")
                  ]),
                  leading: Icon(Icons.image),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WallpaperAndStyleView(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            MenuListGroup(
              groupTitle: AppLocalizations.of(context).translate("settings_category_miscellaneous"),
              itemList: [
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_applanguage"),
                  description: StringUtils.formatString("{0}", [
                    settingsInstance.localeAuto
                        ? AppLocalizations.of(context).translate("settings_option_applanguage_auto")
                        : AppLocalizations.getLocaleDisplayName(settingsInstance.locale),
                  ]),
                  leading: Icon(Icons.translate),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageSettingsView(),
                    ),
                  ),
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_apppermission"),
                  description: AppLocalizations.of(context).translate("settings_option_apppermission_description"),
                  leading: Icon(Icons.security),
                ),
                MenuListGroupItem.toggleButton(
                  title: AppLocalizations.of(context).translate("settings_option_openlinkinsideapp"),
                  description: AppLocalizations.of(context).translate("settings_option_openlinkinsideapp_description"),
                  leading: Icon(Icons.language),
                  switchValue: settingsInstance.openLinkInsideApp,
                  onSwitchChanged: (newValue) => settingsInstance.openLinkInsideApp = newValue,
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_experiemntsettings"),
                  description: AppLocalizations.of(context).translate("settings_option_experiemntsettings_description"),
                  leading: Icon(Icons.science),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExperimentSettingsView(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            MenuListGroup(
              groupTitle: AppLocalizations.of(context).translate("settings_category_aboutandtroubleshoot"),
              itemList: [
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("settings_option_troubleshootnetwork"),
                  description:
                      AppLocalizations.of(context).translate("settings_option_troubleshootnetwork_description"),
                  leading: Icon(Icons.troubleshoot),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NetworkCheckSettingsView(),
                    ),
                  ),
                ),
                MenuListGroupItem(
                  title: StringUtils.formatString(
                    AppLocalizations.of(context).translate("settings_option_about"),
                    [AppLocalizations.of(context).translate("app_name")],
                  ),
                  description: StringUtils.formatString(
                    AppLocalizations.of(context).translate("settings_option_version_description"),
                    [GlobalVariables.appVersion.toString(), GlobalVariables.appBuildNumber.toString()],
                  ),
                  leading: Icon(Icons.info),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutSettingsView(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
