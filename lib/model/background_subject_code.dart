class BackgroundSubjectCode {
  final String studentYearId;
  final String classId;
  final String subjectName;

  BackgroundSubjectCode({
    required this.studentYearId,
    required this.classId,
    required this.subjectName,
  });

  BackgroundSubjectCode.fromJson(Map<String, dynamic> json):
      studentYearId = json["student_year_id"] as String? ?? "",
      classId = json["class_id"] as String? ?? "",
      subjectName = json["subject_name"] as String? ?? "";

  Map<String, dynamic> toJson() {
    return {
      "student_year_id": studentYearId,
      "class_id": classId,
      "subject_name": subjectName,
    };
  }
}
