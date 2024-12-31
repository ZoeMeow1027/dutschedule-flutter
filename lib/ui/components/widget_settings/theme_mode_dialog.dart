import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_localizations.dart';
import '../../../viewmodel/settings_instance.dart';
import '../option_item.dart';

class ThemeModeDialog extends StatelessWidget {
  const ThemeModeDialog({
    super.key,
    required this.selectedMode,
    this.onSelectModeChanged,
    required this.accentColor,
    required this.onAccentColorModeChanged,
  });

  final ThemeMode selectedMode;
  final Function(ThemeMode)? onSelectModeChanged;
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
            Column(
              children: _getThemeModeOptions(context)
                  .entries
                  .map(
                    (e) => OptionItem(
                      paddingInside: const EdgeInsets.symmetric(vertical: 7),
                      title: e.value,
                      onClick: () {
                        onSelectModeChanged?.call(e.key);
                      },
                      leading: Radio<ThemeMode>(
                        value: e.key,
                        groupValue: selectedMode,
                        onChanged: (value) {
                          if (value != null) {
                            onSelectModeChanged?.call(e.key);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            OptionItem(
              paddingInside: const EdgeInsets.symmetric(vertical: 7),
              title: AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_dynamiccolor"),
              onClick: () {
                onAccentColorModeChanged?.call(!accentColor);
              },
              leading: Checkbox(
                onChanged: (value) {
                  onAccentColorModeChanged?.call(value ?? !accentColor);
                },
                value: accentColor,
              ),
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

  Map<ThemeMode, String> _getThemeModeOptions(BuildContext context) {
    return {
      ThemeMode.system: AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_followdevice"),
      ThemeMode.light: AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_light"),
      ThemeMode.dark: AppLocalizations.of(context).translate("settings_dialog_apptheme_choice_dark"),
    };
  }
}
