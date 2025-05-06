class NotificationHistory {
  final String id;
  final String title;
  final String description;
  final int tag;
  final int unixTime;
  final Map<String, String> parameters;
  final bool isRead;
  final bool isNotified;

  NotificationHistory({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.unixTime,
    required this.parameters,
    required this.isRead,
    required this.isNotified,
  });

  NotificationHistory clone({
    String? id,
    String? title,
    String? description,
    int? tag,
    int? unixTime,
    Map<String, String>? parameters,
    bool? isRead,
    bool? isNotified,
  }) {
    return NotificationHistory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      unixTime: unixTime ?? this.unixTime,
      parameters: parameters ?? this.parameters,
      isRead: isRead ?? this.isRead,
      isNotified: isNotified ?? this.isNotified,
    );
  }

  bool isEqualId(NotificationHistory item) {
    return id == item.id;
  }
}
