class EducationModel {
  final String course;
  final String schoolName;
  final String studyLevel;
  final String startYear;
  final String endYear;
  String? key; // Add a key field

  EducationModel({
    required this.course,
    required this.schoolName,
    required this.studyLevel,
    required this.startYear,
    required this.endYear,
    this.key, // Initialize key as optional
  });
  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'study_level': studyLevel,
      'course': course,
      'start_year': startYear,
      'end_year': endYear,
    };
  }
}
