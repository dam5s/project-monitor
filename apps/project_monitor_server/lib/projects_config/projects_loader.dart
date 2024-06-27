import 'package:networking_support/networking_support.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';

class ProjectsConfigLoader {
  final ProjectsRepo projects;

  ProjectsConfigLoader({required this.projects});

  Future<void> loadInitialProjects() async {
    // TODO
  }
}

final class ProjectsConfig {
  final Iterable<ProjectFields> projects;

  ProjectsConfig({required this.projects});

  factory ProjectsConfig.fromJson(JsonDecoder decoder) => ProjectsConfig(
        projects: decoder.objectArray("projects", decodeProjectFields),
      );
}

ProjectFields decodeProjectFields(JsonDecoder decoder) => ProjectFields(
      name: decoder.field("name"),
      repoOwner: decoder.field("repoOwner"),
      repoName: decoder.field("repoName"),
    );
