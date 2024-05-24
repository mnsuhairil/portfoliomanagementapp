class ProjectModel {
  final String key; // Key from Firebase
  final String name;
  final String description;
  final String core;
  final String projectType;
  final String status;
  final String priority;
  final int teamMember;
  final String timelineStart;
  final String timelineEnd;
  final String displayedImage;
  final String repositoryLink;
  final String youtubeLink;
  final List<dynamic> images; // List for project images

  ProjectModel({
    required this.key,
    required this.name,
    required this.description,
    required this.core,
    required this.projectType,
    required this.status,
    required this.priority,
    required this.teamMember,
    required this.timelineStart,
    required this.timelineEnd,
    required this.displayedImage,
    required this.repositoryLink,
    required this.youtubeLink,
    required this.images, // Include images in the constructor
  });
}
