import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/app_localizations.dart';
import '../../utils/app_utils.dart';
import '../components/listview_group_item.dart';
import '../components/listview_option_item.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: "Notifications",
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: "Refresh news in background settings",
                  description: "Configure your notifications, include fetch duration, what news will notify and more.",
                  leading: Icon(Icons.calendar_month),
                ),
                ListViewOptionItem(
                  title: "Subject news parse type",
                  description: "Enabled (parse for news subject)",
                  leading: Icon(Icons.calendar_month),
                ),
                ListViewOptionItem(
                  title: "Notification settings outside app",
                  description: "Click to manage them in system settings",
                  leading: Icon(Icons.notifications),
                  onClick: () {
                    AppUtils.openSystemNotificationSettings();
                  },
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: "Appearance",
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: "App theme",
                  description: "Follow system theme (dynamic color is on)",
                  leading: Icon(Icons.color_lens),
                ),
                ListViewOptionItem(
                  title: "Black background",
                  description: "On",
                  leading: Icon(Icons.contrast),
                  trailing: Switch(
                    onChanged: (value) {},
                    value: true,
                  ),
                ),
                ListViewOptionItem(
                  title: "Wallpaper & style",
                  description: "None",
                  leading: Icon(Icons.image),
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: "Miscellaneous settings",
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: "App theme",
                  description: "Follow system theme (dynamic color is on)",
                  leading: Icon(Icons.color_lens),
                ),
                ListViewOptionItem(
                  title: "App theme",
                  description: "Follow system theme (dynamic color is on)",
                  leading: Icon(Icons.color_lens),
                ),
                ListViewOptionItem(
                  title: "App theme",
                  description: "Follow system theme (dynamic color is on)",
                  leading: Icon(Icons.color_lens),
                ),
                ListViewOptionItem(
                  title: "App theme",
                  description: "Follow system theme (dynamic color is on)",
                  leading: Icon(Icons.color_lens),
                ),
              ],
            ),
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: "About",
              children: [
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) => ListViewOptionItem(
                    title: AppLocalizations.of(context).translate("appname"),
                    description: snapshot.connectionState == ConnectionState.done ? "v${snapshot.data?.version} (${snapshot.data?.buildNumber})" : "(unknown)",
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
