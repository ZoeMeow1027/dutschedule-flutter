import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_localizations.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/switch_with_surface.dart';

class ParseNewsSubjectNotificationsView extends StatelessWidget {
  const ParseNewsSubjectNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_parsenewssubject_title")),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settingsInstance.newsBackgroundParseNewsSubject
                              ? AppLocalizations.of(context).translate("settings_parsenewssubject_preview_titleenabled")
                              : AppLocalizations.of(context)
                                  .translate("settings_parsenewssubject_preview_titledisabled"),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            settingsInstance.newsBackgroundParseNewsSubject
                                ? AppLocalizations.of(context)
                                    .translate("settings_parsenewssubject_preview_descenabled")
                                : AppLocalizations.of(context)
                                    .translate("settings_parsenewssubject_preview_descdisabled"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SwitchWithSurface(
                title: AppLocalizations.of(context).translate("settings_parsenewssubject_choice_enable"),
                value: settingsInstance.newsBackgroundParseNewsSubject,
                onClick: (changedValue) {
                  settingsInstance.newsBackgroundParseNewsSubject = changedValue;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      size: 24,
                    ),
                    Text(AppLocalizations.of(context).translate("settings_parsenewssubject_info")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
