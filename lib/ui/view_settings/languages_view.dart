import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_languages.dart';
import '../../utils/app_localizations.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/listview_option_item.dart';

class LanguageSettingsView extends StatelessWidget {
  const LanguageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_applanguage_title")),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            AppLanguages.localeCodeList.length + 1,
            (index) {
              if (index == 0) {
                return ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_applanguage_yoursystemlang"),
                  trailing: settingsInstance.localeAuto ? Icon(Icons.check) : null,
                  onClick: () => settingsInstance.localeAuto = true,
                );
              } else {
                return ListViewOptionItem(
                  title: AppLanguages.localeCodeList.entries.elementAt(index - 1).value,
                  trailing: settingsInstance.localeAuto
                      ? null
                      : settingsInstance.locale.languageCode ==
                              AppLanguages.localeCodeList.entries.elementAt(index - 1).key
                          ? Icon(Icons.check)
                          : null,
                  onClick: () {
                    settingsInstance.localeAuto = false;
                    settingsInstance.locale = Locale(AppLanguages.localeCodeList.entries.elementAt(index - 1).key);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
