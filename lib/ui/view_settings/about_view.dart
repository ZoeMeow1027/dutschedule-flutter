import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';

import '../../global_variables.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../components/menu_list_group.dart';

class AboutSettingsView extends StatelessWidget {
  const AboutSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_about_title")),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/icons/app_icon_512.png'),
                    width: 128,
                    height: 128,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context).translate("app_name"),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                AppLocalizations.of(context).translate("settings_about_madewith"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  StringUtils.formatString(
                    AppLocalizations.of(context).translate("settings_option_version_description"),
                    [GlobalVariables.appVersion.toString(), GlobalVariables.appBuildNumber.toString()],
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              MenuListGroup(
                itemList: [
                  MenuListGroupItem(
                    title: AppLocalizations.of(context).translate("settings_about_changelog"),
                    description: AppLocalizations.of(context).translate("settings_about_changelog_description"),
                    leading: Icon(Icons.restore_rounded),
                    onClick: () => context.openUrl(GlobalVariables.repoLinkChangelog),
                  ),
                  MenuListGroupItem(
                    title: AppLocalizations.of(context).translate("settings_about_license"),
                    description: AppLocalizations.of(context).translate("settings_about_license_mit"),
                    leading: Icon(Icons.description),
                    onClick: () => context.openUrl(GlobalVariables.repoLinkLicense),
                  ),
                  MenuListGroupItem(
                    title: AppLocalizations.of(context).translate("settings_about_credit"),
                    description: AppLocalizations.of(context).translate("settings_about_credit_description"),
                    leading: Icon(Icons.extension),
                    onClick: () => context.openUrl(GlobalVariables.repoLinkCredits),
                  ),
                  MenuListGroupItem(
                    title: AppLocalizations.of(context).translate("settings_about_github"),
                    description: GlobalVariables.repoLink,
                    leading: Icon(Icons.info),
                    onClick: () => context.openUrl(GlobalVariables.repoLink),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
