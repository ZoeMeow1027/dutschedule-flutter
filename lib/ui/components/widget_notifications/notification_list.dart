import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../model/notification_history.dart';
import 'notification_list_by_date.dart';

class WidgetMainNotificationList extends StatelessWidget {
  const WidgetMainNotificationList({
    super.key,
    required this.notifyHistoryList,
    this.onClick,
    this.onDelete,
  });

  final List<NotificationHistory> notifyHistoryList;
  final Function(NotificationHistory)? onClick;
  final Function(NotificationHistory)? onDelete;

  @override
  Widget build(BuildContext context) {
    var tmp = groupBy(
      notifyHistoryList,
      (NotificationHistory item) {
        var dateTime = DateTime.fromMillisecondsSinceEpoch(item.dateNotificationReceived).toLocal();
        return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0).millisecondsSinceEpoch;
      },
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          tmp.length,
          (index) {
            var item = tmp.entries.elementAt(index);
            return WidgetMainNotificationListByDate(
              date: item.key,
              notificationList: item.value,
              onClick: (item) {
                onClick?.call(item);
              },
              onDelete: (item) {
                onDelete?.call(item);
              },
            );
          },
        ),
      ),
    );
  }
}
