import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../global_variables.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_utils.dart';
import '../../utils/string_utils.dart';
import '../components/list_view_option_item.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/app_icon_512.png'),
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
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) => Text(
                    snapshot.connectionState == ConnectionState.done
                        ? StringUtils.formatString(
                            AppLocalizations.of(context).translate("settings_option_version_description"),
                            [snapshot.data?.version.toString() ?? "0", snapshot.data?.buildNumber.toString() ?? "0"],
                          )
                        : "(Unknown)",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              ListViewOptionItem(
                title: AppLocalizations.of(context).translate("settings_about_changelog"),
                description: AppLocalizations.of(context).translate("settings_about_changelog_description"),
                leading: Icon(Icons.restore_rounded),
                onClick: () => AppUtils.launchOwnUrl(GlobalVariables.repoLinkChangelog),
              ),
              ListViewOptionItem(
                title: AppLocalizations.of(context).translate("settings_about_license"),
                description: AppLocalizations.of(context).translate("settings_about_license_mit"),
                leading: Icon(Icons.info),
                onClick: () => AppUtils.launchOwnUrl(GlobalVariables.repoLinkLicense),
              ),
              ListViewOptionItem(
                title: AppLocalizations.of(context).translate("settings_about_credit"),
                description: AppLocalizations.of(context).translate("settings_about_credit_description"),
                leading: Icon(Icons.info),
                onClick: () => AppUtils.launchOwnUrl(GlobalVariables.repoLinkCredits),
              ),
              ListViewOptionItem(
                title: AppLocalizations.of(context).translate("settings_about_github"),
                description: GlobalVariables.repoLink,
                leading: Icon(Icons.science),
                onClick: () => AppUtils.launchOwnUrl(GlobalVariables.repoLink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
