import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/enum/background_image_option.dart';
import '../../utils/app_localizations.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/menu_list_group.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            MenuListGroup(
              groupTitle: AppLocalizations.of(context).translate("settings_wallpaperandcontrols_category_enabled"),
              itemMinHeight: 60,
              itemList: [
                MenuListGroupItem.radioButton(
                  title: AppLocalizations.of(context).translate("settings_wallpaperandcontrols_choice_none"),
                  radioValue: BackgroundImageOption.none,
                  currentValue: settingsInstance.backgroundImageOption,
                  onRadioClicked: () {
                    // TODO: Remove all background here.
                    settingsInstance.backgroundImageOption = BackgroundImageOption.none;
                  },
                ),
                MenuListGroupItem.radioButton(
                  title:
                      AppLocalizations.of(context).translate("settings_wallpaperandcontrols_choice_currentwallpaper"),
                  description: '...', // TODO: Check if qualified.
                  radioValue: BackgroundImageOption.currentWallpaper,
                  currentValue: settingsInstance.backgroundImageOption,
                  onRadioClicked: () {
                    // TODO: Check if can continue.
                    // settingsInstance.backgroundImageOption = BackgroundImageOption.currentWallpaper;
                  },
                ),
                MenuListGroupItem.radioButton(
                  title: AppLocalizations.of(context).translate("settings_wallpaperandcontrols_choice_pickanimage"),
                  radioValue: BackgroundImageOption.yourPickedImage,
                  currentValue: settingsInstance.backgroundImageOption,
                  onRadioClicked: () {
                    // TODO: Pick an image before continue.
                    // settingsInstance.backgroundImageOption = BackgroundImageOption.yourPickedImage;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
