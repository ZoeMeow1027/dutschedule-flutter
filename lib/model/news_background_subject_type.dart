enum NewsBackgroundSubjectType {
  /// News subject will not notify user.
  none(-1),
  /// All subject news will notify user.
  allNews(0),
  /// All subjects from user schedule will notify.
  yourSchedule(1),
  /// All subject news will notify user except user filter list.
  yourFilterList(2);

  final int value;
  const NewsBackgroundSubjectType(this.value);
}