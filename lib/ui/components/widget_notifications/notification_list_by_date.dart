import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/notification_history.dart';
import 'notification_item.dart';

class WidgetMainNotificationListByDate extends StatelessWidget {
  const WidgetMainNotificationListByDate({
    super.key,
    required this.date,
    required this.notificationList,
    this.onClick,
    this.onDelete,
  });

  final int date;
  final List<NotificationHistory> notificationList;
  final Function(NotificationHistory)? onClick, onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: _listWithDate(
        context: context,
        date: date,
        notificationList: notificationList,
        onClick: onClick,
        onDelete: onDelete,
      ),
    );
  }

  List<Widget> _listWithDate({
    required BuildContext context,
    required int date,
    required List<NotificationHistory> notificationList,
    Function(NotificationHistory)? onClick,
    Function(NotificationHistory)? onDelete,
  }) {
    List<Widget> list = [
      Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: Text(
          DateFormat("EE, dd/MM/yyyy", Localizations.localeOf(context).toString()).format(
            DateTime.fromMillisecondsSinceEpoch(date),
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
      ),
    ];
    notificationList.forEachIndexed((index, notificationItem) {
      list.add(WidgetMainNotificationItem(
        notifyHistoryItem: notificationItem,
        shouldRadiusOnTop: index == 0,
        shouldRadiusOnBottom: index == (notificationList.length - 1),
        onClick: onClick,
        onDelete: onDelete,
      ));
    });

    return list;
  }
}
