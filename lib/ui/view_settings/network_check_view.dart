import 'package:dutwrapper/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../model/enum/app_log_level.dart';
import '../../model/enum/background_image_option.dart';
import '../../utils/app_utils.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/card_with_title.dart';

class NetworkCheckSettingsView extends StatefulWidget {
  const NetworkCheckSettingsView({super.key});

  @override
  State<StatefulWidget> createState() => _NetworkCheckSettingsView();
}

class _NetworkCheckSettingsView extends State<NetworkCheckSettingsView> {
  // -1: Not reached, 0: Running, 1: Failed, 2: Successful
  int _hasConnectedToInternet = -1, _hasDutSvOnline = -1;
  bool _isRunning = false;
  int _lastRequest = 0;

  Future<void> _fetchStatus2() async {
    setState(() {
      _isRunning = true;
      _lastRequest = DateTime.now().toUtc().millisecondsSinceEpoch;
      _hasConnectedToInternet = -1;
      _hasDutSvOnline = -1;
    });
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'Diagnostics',
      subTag: 'Network',
      message: 'Starting check...',
    );
    await Future.delayed(Duration(milliseconds: 500));
    try {
      setState(() => _hasConnectedToInternet = 0);
      await Utils.ensureNetworkHaveInternet();
      setState(() => _hasConnectedToInternet = 2);
    } catch (_) {
      setState(() => _hasConnectedToInternet = 1);
    }
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'Diagnostics',
      subTag: 'Network',
      message: 'Done checking internet connection...',
    );
    await Future.delayed(Duration(milliseconds: 500));
    if (_hasConnectedToInternet != 2) {
      setState(() {
        // TODO: Show notify about not have internet connection here.
        AppUtils.showLogToDebug(
          resultTag: AppLogLevel.error,
          tag: 'Diagnostics',
          subTag: 'Network',
          message: 'You haven\'t connected to internet.',
        );
      });
    } else {
      try {
        setState(() => _hasDutSvOnline = 0);
        await Utils.ensureNetworkDutSvOnline();
        setState(() => _hasDutSvOnline = 2);
      } catch (_) {
        setState(() => _hasDutSvOnline = 1);
      }
    }
    if (_hasDutSvOnline == 2) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Diagnostics',
        subTag: 'Network',
        message: 'DUT server is online!',
      );
    } else {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Diagnostics',
        subTag: 'Network',
        message: 'DUT server downed or you have blocked sv.dut.udn.vn.',
      );
    }
    setState(() {
      _isRunning = false;
      _lastRequest = DateTime.now().toUtc().millisecondsSinceEpoch;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchStatus2();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // title: Text(AppLocalizations.of(context).translate("settings_about_title")),
        title: Text(AppLocalizations.of(context).translate("settings_troubleshoot_network_title")),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: switch (_isRunning) {
            true => LinearProgressIndicator(),
            false => Center(),
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: settingsInstance.backgroundImageOption == BackgroundImageOption.none ? null : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 24),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          StringUtils.formatString(
                            AppLocalizations.of(context).translate("time_last_request"),
                            [
                              _isRunning
                                  ? AppLocalizations.of(context).translate("settings_troubleshoot_running")
                                  : _lastRequest == 0
                                      ? AppLocalizations.of(context).translate("data_unknown")
                                      : DateFormat("dd/MM/yyyy HH:mm").format(
                                          DateTime.fromMillisecondsSinceEpoch(_lastRequest),
                                        ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: () async {
                await _fetchStatus2();
              },
              child: _isRunning
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh, size: 24),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    AppLocalizations.of(context).translate("settings_troubleshoot_network_description"),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    _isRunning
                        ? AppLocalizations.of(context).translate("settings_troubleshoot_network_running")
                        : _hasConnectedToInternet != 2
                            ? AppLocalizations.of(context).translate("settings_troubleshoot_network_nointernet")
                            : _hasDutSvOnline != 2
                                ? AppLocalizations.of(context).translate("settings_troubleshoot_network_serveroffline")
                                : AppLocalizations.of(context).translate("settings_troubleshoot_network_serveronline"),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                CardWithTitle(
                  title: AppLocalizations.of(context).translate("settings_troubleshoot_network_card_internet_title"),
                  child: Text(AppLocalizations.of(context).translate(switch (_hasConnectedToInternet) {
                    2 => "settings_troubleshoot_network_card_internet_connected",
                    1 => "settings_troubleshoot_network_card_internet_failed",
                    0 => "settings_troubleshoot_running",
                    -1 => "settings_troubleshoot_waitanothertask",
                    _ => "data_unknown",
                  })),
                ),
                CardWithTitle(
                  title: AppLocalizations.of(context).translate("settings_troubleshoot_network_card_server_title"),
                  child: Text(AppLocalizations.of(context).translate(switch (_hasDutSvOnline) {
                    2 => "settings_troubleshoot_network_card_server_online",
                    1 => "settings_troubleshoot_network_card_server_offline",
                    0 => "settings_troubleshoot_running",
                    -1 => "settings_troubleshoot_waitanothertask",
                    _ => "data_unknown",
                  })),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
