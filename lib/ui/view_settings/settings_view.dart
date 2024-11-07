import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../model/enum/background_image_option.dart';
import '../../utils/app_languages.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_utils.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/listview_group_item.dart';
import '../components/listview_option_item.dart';
import 'languages_view.dart';
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
        child: Column(
          children: [
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_category_notifications"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_newsschedule"),
                  description: AppLocalizations.of(context).translate("settings_option_newsschedule_description"),
                  leading: Icon(Icons.calendar_month),
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_parsenewssubject_title"),
                  description: settingsInstance.newsBackgroundParseNewsSubject
                      ? AppLocalizations.of(context).translate("settings_newsnotify_parsenewssubject_enabled")
                      : AppLocalizations.of(context).translate("settings_newsnotify_parsenewssubject_disabled"),
                  leading: Icon(Icons.calendar_month),
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_notificationoutside"),
                  description:
                      AppLocalizations.of(context).translate("settings_option_notificationoutside_description"),
                  leading: Icon(Icons.notifications),
                  onClick: () {
                    AppUtils.openSystemNotificationSettings();
                  },
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_category_appearance"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_apptheme"),
                  description: StringUtils.formatString("{0} {1}", [
                    settingsInstance.themeMode == ThemeMode.system
                        ? AppLocalizations.of(context).translate("settings_option_apptheme_choice_followdevice")
                        : settingsInstance.themeMode == ThemeMode.light
                            ? AppLocalizations.of(context).translate("settings_option_apptheme_choice_light")
                            : AppLocalizations.of(context).translate("settings_option_apptheme_choice_dark"),
                    settingsInstance.accentColor
                        ? AppLocalizations.of(context).translate("settings_option_apptheme_choice_dynamiccolorenabled")
                        : ""
                  ]),
                  leading: Icon(Icons.color_lens),
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_blackbackground"),
                  description: AppLocalizations.of(context).translate("settings_option_blackbackground_description"),
                  leading: Icon(Icons.contrast),
                  trailing: Switch(
                    onChanged: (value) {
                      settingsInstance.blackBackground = value;
                    },
                    value: settingsInstance.blackBackground,
                  ),
                  onClick: () => settingsInstance.blackBackground = !settingsInstance.blackBackground,
                ),
                ListViewOptionItem(
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
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_category_miscellaneous"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_applanguage"),
                  description: StringUtils.formatString("{0}", [
                    settingsInstance.localeAuto
                        ? AppLocalizations.of(context).translate("settings_option_applanguage_auto")
                        : AppLanguages.getLocaleDisplayName(settingsInstance.locale),
                  ]),
                  leading: Icon(Icons.language),
                  onClick: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageSettingsView(),
                    ),
                  ),
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_apppermission"),
                  description: AppLocalizations.of(context).translate("settings_option_apppermission_description"),
                  leading: Icon(Icons.security),
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_openlinkinsideapp"),
                  description: AppLocalizations.of(context).translate("settings_option_openlinkinsideapp_description"),
                  leading: Icon(Icons.language),
                  trailing: Switch(
                    onChanged: (value) {
                      settingsInstance.openLinkInsideApp = value;
                    },
                    value: settingsInstance.openLinkInsideApp,
                  ),
                  onClick: () => settingsInstance.openLinkInsideApp = !settingsInstance.openLinkInsideApp,
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_option_experiemntsettings"),
                  description: AppLocalizations.of(context).translate("settings_option_experiemntsettings_description"),
                  leading: Icon(Icons.science),
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_category_about"),
              children: [
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) => ListViewOptionItem(
                    title: StringUtils.formatString(
                      AppLocalizations.of(context).translate("settings_option_about"),
                      [AppLocalizations.of(context).translate("app_name")],
                    ),
                    description: snapshot.connectionState == ConnectionState.done
                        ? StringUtils.formatString(
                            AppLocalizations.of(context).translate("settings_option_version_description"),
                            [snapshot.data?.version.toString() ?? "0", snapshot.data?.buildNumber.toString() ?? "0"],
                          )
                        : AppLocalizations.of(context).translate("data_unknown"),
                    leading: Icon(Icons.info),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
