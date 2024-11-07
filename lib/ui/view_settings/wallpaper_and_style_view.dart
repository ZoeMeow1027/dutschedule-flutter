import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/enum/background_image_option.dart';
import '../../utils/app_localizations.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/listview_group_item.dart';
import '../components/listview_option_item.dart';

class WallpaperAndStyleView extends StatelessWidget {
  const WallpaperAndStyleView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("settings_wallpaperandcontrols_title")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListViewGroupItem(
              padding: const EdgeInsets.only(top: 10),
              title: AppLocalizations.of(context).translate("settings_wallpaperandcontrols_category_enabled"),
              dividerOnBottom: true,
              children: [
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_wallpaperandcontrols_choice_none"),
                  onClick: () {
                    // TODO: Remove all background here.
                    settingsInstance.backgroundImageOption = BackgroundImageOption.none;
                  },
                  leading: Radio<BackgroundImageOption>(
                    value: BackgroundImageOption.none,
                    groupValue: settingsInstance.backgroundImageOption,
                    onChanged: (value) {
                      if (value != null) {
                        // TODO: Remove all background here.
                        settingsInstance.backgroundImageOption = value;
                      }
                    },
                  ),
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_wallpaperandcontrols_choice_currentwallpaper"),
                  description: null, // TODO: Check if qualified.
                  onClick: () {
                    // TODO: Check if can continue.
                  },
                  leading: Radio<BackgroundImageOption>(
                    value: BackgroundImageOption.currentWallpaper,
                    groupValue: settingsInstance.backgroundImageOption,
                    onChanged: (value) {
                      if (value != null) {
                        // TODO: Check if can continue.
                      }
                    },
                  ),
                ),
                ListViewOptionItem(
                  title: AppLocalizations.of(context).translate("settings_wallpaperandcontrols_choice_pickaimage"),
                  onClick: () {
                    // TODO: Pick an image before continue.
                  },
                  leading: Radio<BackgroundImageOption>(
                    value: BackgroundImageOption.yourPickedImage,
                    groupValue: settingsInstance.backgroundImageOption,
                    onChanged: (value) {
                      if (value != null) {
                        // TODO: Pick an image before continue.
                      }
                    },
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