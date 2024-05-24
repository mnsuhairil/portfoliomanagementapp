class WorkExperienceModel {
  final String position;
  final String companyName;
  final String startDate;
  final String endDate;
  String? key; // Add a key field

  WorkExperienceModel({
    required this.position,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    this.key, // Initialize key as optional
  });

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'company_name': companyName,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
