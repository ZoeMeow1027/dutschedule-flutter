import 'package:flutter/material.dart';

class WidgetMainNotificationEmpty extends StatelessWidget {
  const WidgetMainNotificationEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'You have no notifications',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'When you have any notifications, it will show up here.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
