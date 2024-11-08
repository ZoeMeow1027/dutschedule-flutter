import '../../../utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/settings_instance.dart';
import '../../view_settings/settings_view.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("appname")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              settingsInstance.setLocale(Locale("en", "US"));
            },
            child: const Text("en-us"),
          ),
          TextButton(
            onPressed: () {
              settingsInstance.setLocale(Locale("vi"));
            },
            child: const Text("vi"),
          ),
        ],
      ),
    );
  }
}
