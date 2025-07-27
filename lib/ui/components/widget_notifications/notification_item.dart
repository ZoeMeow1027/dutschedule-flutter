import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/notification_history.dart';
import '../../../utils/build_context_extension.dart';

class WidgetMainNotificationItem extends StatefulWidget {
  const WidgetMainNotificationItem({
    super.key,
    required this.notifyHistoryItem,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.showFullDateTime = false,
    this.showDeleteButton = true,
    this.onClick,
    this.onDelete,
  });

  final NotificationHistory notifyHistoryItem;
  final bool shouldRadiusOnTop;
  final bool shouldRadiusOnBottom;
  final bool showDeleteButton;
  final bool showFullDateTime;
  final Function(NotificationHistory)? onClick;
  final Function(NotificationHistory)? onDelete;

  @override
  State<StatefulWidget> createState() => _WidgetMainNotificationItem();
}

class _WidgetMainNotificationItem extends State<WidgetMainNotificationItem> {
  // Convert this to duration (3 days ago,...)
  String notificationDate = '';

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!mounted) return; // bail out if widget is disposed
      setState(() {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(widget.notifyHistoryItem.dateNotificationReceived);
        final stringTime = DateFormat(
          switch (widget.showFullDateTime) { false => "HH:mm", true => "dd/MM/yyyy HH:mm" },
          Localizations.localeOf(context).toString(),
        ).format(dateTime);
        final stringDuration = context.getDurationFromCurrent(dateTime);
        final stringFinal = '$stringTime ($stringDuration)';
        if (notificationDate.compareTo(stringFinal) != 0) {
          notificationDate = stringFinal;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final notificationDate = DateFormat("dd/MM/yyyy HH:mm", Localizations.localeOf(context).toString()).format(
    //   DateTime.fromMillisecondsSinceEpoch(notifyHistoryItem.dateNotificationReceived),
    // );
    final notificationTitle = widget.notifyHistoryItem.title;
    final notificationItemDate = widget.notifyHistoryItem.dateItemReceived == 0
        ? ''
        : '\n🕓 ${DateFormat("dd/MM/yyyy", Localizations.localeOf(context).toString()).format(
            DateTime.fromMillisecondsSinceEpoch(widget.notifyHistoryItem.dateItemReceived),
          )}';
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(widget.shouldRadiusOnTop ? 20 : 5),
        topLeft: Radius.circular(widget.shouldRadiusOnTop ? 20 : 5),
        bottomLeft: Radius.circular(widget.shouldRadiusOnBottom ? 20 : 5),
        bottomRight: Radius.circular(widget.shouldRadiusOnBottom ? 20 : 5),
      ),
      child: InkWell(
        onTap: widget.onClick == null
            ? null
            : () {
                widget.onClick?.call(widget.notifyHistoryItem);
              },
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(notificationDate),
                  switch (widget.showDeleteButton) {
                    true => IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          widget.onDelete?.call(widget.notifyHistoryItem);
                        },
                      ),
                    false => Container(),
                  },
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              Text(
                '$notificationTitle$notificationItemDate',
                // overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  widget.notifyHistoryItem.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
