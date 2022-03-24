enum ProjectStatus { ready, processing, error }

ProjectStatus stringToProjectStatus(String value) {
  const Map<String, ProjectStatus> mapping = {
    "ready": ProjectStatus.ready,
    "processing": ProjectStatus.processing,
    "error": ProjectStatus.error
  };

  if (mapping.containsKey(value)) {
    return mapping[value]!;
  }
  return ProjectStatus.error;
}

class Project {
  final ProjectStatus projectStatus;
  final String name;

  Project({required this.projectStatus, required this.name});

  factory Project.fromMap(Map<String, dynamic> json) {
    return Project(
        projectStatus: stringToProjectStatus(json['status']),
        name: json['name']);
  }
}
