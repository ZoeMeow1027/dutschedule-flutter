class NotificationHistory {
  final String id;
  final String title;
  final String description;
  final String tag;
  final String type;
  // Original date unix for received item
  final int dateItemReceived;
  // Date unix when item is received
  final int dateNotificationReceived;
  final Map<String, String> parameters;
  final bool isRead;
  final bool isNotifiedToOs;

  NotificationHistory({
    String? id,
    required this.title,
    required this.description,
    required this.tag,
    required this.type,
    this.dateItemReceived = 0,
    int? dateNotificationReceived,
    required this.parameters,
    this.isRead = false,
    this.isNotifiedToOs = false,
  })  : id = id ?? DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        dateNotificationReceived = dateNotificationReceived ?? DateTime.now().toUtc().millisecondsSinceEpoch;

  NotificationHistory.fromJson({required Map<String, dynamic> data})
      :
        // Random if not generated
        id = (data['id'] as String?) ?? DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        title = (data['title'] as String?) ?? '',
        description = (data['description'] as String?) ?? '',
        tag = (data['tag'] as String?) ?? '',
        type = (data['type'] as String?) ?? '',
        dateItemReceived = (data['date_item_received'] as int?) ?? 0,
        dateNotificationReceived = (data['date_notification_received'] as int?) ?? 0,
        isRead = (data['is_read'] as bool?) ?? false,
        isNotifiedToOs = (data['is_notified_os'] as bool?) ?? false,
        parameters = (data['parameters'] as Map<String, dynamic>? ?? {}).map((p, q) => MapEntry(p, q));

  NotificationHistory clone({
    String? id,
    String? title,
    String? description,
    String? tag,
    String? type,
    int? dateItemReceived,
    int? dateNotificationReceived,
    Map<String, String>? parameters,
    bool? isRead,
    bool? isNotifiedToOs,
  }) {
    return NotificationHistory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      dateItemReceived: dateItemReceived ?? this.dateItemReceived,
      dateNotificationReceived: dateNotificationReceived ?? this.dateNotificationReceived,
      parameters: parameters ?? this.parameters,
      isRead: isRead ?? this.isRead,
      isNotifiedToOs: isNotifiedToOs ?? this.isNotifiedToOs,
    );
  }

  bool isEqualId(NotificationHistory item) {
    return id == item.id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tag': tag,
      'type': type,
      'date_item_received': dateItemReceived,
      'date_notification_received': dateNotificationReceived,
      'is_read': isRead,
      'is_notified_os': isNotifiedToOs,
      'parameters': parameters,
    };
  }
}
