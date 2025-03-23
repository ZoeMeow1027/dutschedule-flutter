class NotificationHistory {
  final List<NotificationHistoryItem> list = [];

  NotificationHistory();
}

class NotificationHistoryItem {
  final String id;
  final String title;
  final String description;
  final int tag;
  final int timestamp;
  final Map<String, String> parameters;
  final bool isRead;
  final bool isNotified;

  NotificationHistoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.timestamp,
    required this.parameters,
    required this.isRead,
    required this.isNotified,
  });

  NotificationHistoryItem clone({
    String? id,
    String? title,
    String? description,
    int? tag,
    int? timestamp,
    Map<String, String>? parameters,
    bool? isRead,
    bool? isNotified,
  }) {
    return NotificationHistoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      timestamp: timestamp ?? this.timestamp,
      parameters: parameters ?? this.parameters,
      isRead: isRead ?? this.isRead,
      isNotified: isNotified ?? this.isNotified,
    );
  }

  bool isEqualId(NotificationHistoryItem item) {
    return id == item.id;
  }
}
