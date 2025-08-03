import 'package:collection/collection.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../viewmodel/notification_instance.dart';
import '../../../viewmodel/settings_instance.dart';
import '../../components/widget_news/news_detail_item.dart';
import '../../components/widget_notifications/notification_empty.dart';
import '../../components/widget_notifications/notification_item.dart';
import '../../components/widget_notifications/notification_list.dart';
import '../../view_news/news_detail_view.dart';
import '../../view_settings/settings_view.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);
    final notificationInstance = Provider.of<NotificationInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("notification_panel_title")),
        actions: [
          switch (notificationInstance.notificationHistoryList.isNotEmpty) {
            true => Padding(
                padding: const EdgeInsets.only(right: 5),
                child: FilledButton.tonalIcon(
                  onPressed: () async {
                    // Delete all notifications
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(AppLocalizations.of(context).translate("main_notifications_dialog_deleteall")),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)
                                  .translate("main_notifications_dialog_deleteall_description")),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(AppLocalizations.of(context).translate('action_delete')),
                            onPressed: () {
                              Navigator.pop(context);
                              notificationInstance.removeAllNotifications();
                            },
                          ),
                          TextButton(
                            child: Text(AppLocalizations.of(context).translate('action_cancel')),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.clear_all, size: 26),
                  label: Text(AppLocalizations.of(context).translate('main_notifications_deleteall')),
                ),
              ),
            false => Container(),
          },
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
      body: switch (notificationInstance.notificationHistoryList.isEmpty) {
        true => WidgetMainNotificationEmpty(),
        false => WidgetMainNotificationList(
            notifyHistoryList: notificationInstance.notificationHistoryList
                .sorted((p, q) => q.dateNotificationReceived.compareTo(p.dateNotificationReceived)),
            onClick: (item) async {
              if (item.type == 'news') {
                if (settingsInstance.openNewsInModalBottomSheet) {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => FractionallySizedBox(
                      heightFactor: 0.75,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 30),
                        child: NewsDetailItem(
                          newsItem: NewsCore.fromJson(item.parameters['data'] ?? '{}'),
                          isNewsSubject: item.tag.toLowerCase() == 'subject',
                        ),
                      ),
                    ),
                  );
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailView(
                        newsItem: NewsCore.fromJson(item.parameters['data'] ?? '{}'),
                        isNewsSubject: item.tag.toLowerCase() == 'subject',
                      ),
                    ),
                  );
                }
              }
            },
            onDelete: (item) async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).translate('main_notifications_dialog_deleteone')),
                  content: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('main_notifications_dialog_deleteone_description'),
                        ),
                        // TODO: Show notification is being deleted here.
                        WidgetMainNotificationItem(
                          notifyHistoryItem: item,
                          showDeleteButton: false,
                          showFullDateTime: true,
                          shouldRadiusOnBottom: false,
                          shouldRadiusOnTop: false,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(AppLocalizations.of(context).translate('action_delete')),
                      onPressed: () {
                        Navigator.pop(context);
                        notificationInstance.removeNotification(item);
                      },
                    ),
                    TextButton(
                      child: Text(AppLocalizations.of(context).translate('action_cancel')),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
      },
    );
  }
}
