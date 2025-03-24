import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_languages.dart';
import '../../utils/app_localizations.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/list_view_option_item.dart';

class LanguageSettingsView extends StatefulWidget {
  const LanguageSettingsView({super.key});

  @override
  State<StatefulWidget> createState() => _LanguageSettingsView();
}

class _LanguageSettingsView extends State<LanguageSettingsView> {
  String _searchQuery = "";
  final _newsSearchQueryTextControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);
    var searchResult = AppLanguages.localeCodeList.entries.where((p) {
      if (p.key.toLowerCase().contains(_searchQuery)) {
        return true;
      } else if (p.value.toLowerCase().contains(_searchQuery)) {
        return true;
      } else {
        return false;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_applanguage_title")),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: TextField(
              controller: _newsSearchQueryTextControl,
              onChanged: (text) => setState(() {
                _searchQuery = text;
              }),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(AppLocalizations.of(context).translate("settings_option_applanguage_searchhint")),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                searchResult.length + 1,
                (index) {
                  if (index == 0) {
                    return ListViewOptionItem(
                      title: AppLocalizations.of(context).translate("settings_applanguage_yoursystemlang"),
                      trailing: settingsInstance.localeAuto ? Icon(Icons.check) : null,
                      onClick: () {
                        settingsInstance.localeAuto = true;
                      },
                    );
                  } else {
                    return ListViewOptionItem(
                      title: searchResult.elementAt(index - 1).value,
                      trailing: settingsInstance.localeAuto
                          ? null
                          : settingsInstance.locale.languageCode == searchResult.elementAt(index - 1).key
                              ? Icon(Icons.check)
                              : null,
                      onClick: () {
                        settingsInstance.localeAuto = false;
                        settingsInstance.locale = Locale(searchResult.elementAt(index - 1).key);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
