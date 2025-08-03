import 'dart:io';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../model/enum/app_theme_mode.dart';
import '../menu_list_group.dart';

class ThemeModeDialog extends StatelessWidget {
  const ThemeModeDialog({
    super.key,
    required this.selectedMode,
    this.onSelectModeChanged,
    required this.accentColor,
    required this.onAccentColorModeChanged,
  });

  final AppThemeMode selectedMode;
  final Function(AppThemeMode)? onSelectModeChanged;
  final bool accentColor;
  final Function(bool)? onAccentColorModeChanged;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate("settings_dialog_apptheme_title")),
      content: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuListGroup(
              itemMinHeight: 60,
              itemList: List.generate(
                _getThemeModeOptions(context).entries.length,
                (index) {
                  var option = _getThemeModeOptions(context).entries.elementAt(index);
                  return MenuListGroupItem.radioButton(
                    title: option.value,
                    radioValue: option.key,
                    currentValue: selectedMode,
                    onRadioClicked: () {
                      onSelectModeChanged?.call(option.key);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            MenuListGroup(
              itemMinHeight: 60,
              itemList: [
                MenuListGroupItem.checkboxButton(
                  title: AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_dynamiccolor"),
                  switchValue: accentColor,
                  onSwitchChanged: (changedValue) {
                    onAccentColorModeChanged?.call(changedValue);
                  },
                ),
              ],
            ),
            if (Platform.isAndroid || Platform.isWindows)
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info),
                    if (Platform.isAndroid)
                      Text(AppLocalizations.of(context).translate("settings_dialog_apptheme_note_android")),
                    if (Platform.isWindows)
                      Text(AppLocalizations.of(context).translate("settings_dialog_apptheme_note_windows")),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context).translate("action_ok")),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Map<AppThemeMode, String> _getThemeModeOptions(BuildContext context) {
    return {
      AppThemeMode.followSystemSettings:
          AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_followdevice"),
      AppThemeMode.lightMode: AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_light"),
      AppThemeMode.darkMode: AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_dark"),
    };
  }
}
