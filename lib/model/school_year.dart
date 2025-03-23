class SchoolYear {
  final int year;
  final int semester;

  const SchoolYear({
    required this.year,
    required this.semester,
  });

  SchoolYear.fromJson(Map<String, dynamic> json):
      year = json["year"] as int? ?? 24,
      semester = json["semester"] as int? ?? 1;

  Map<String, dynamic> toJson() {
    return {
      "year": year,
      "semester": semester,
    };
  }
}
