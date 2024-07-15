import 'dart:io';

import 'package:networking_support/networking_support.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/projects_config/projects_config.dart';

class ProjectsConfigLoader {
  final ProjectsRepo projects;

  ProjectsConfigLoader({required this.projects});

  Future<void> load({String? filePath}) async {
    filePath ??= "projects.json";

    final jsonString = await File(filePath).readAsString();
    final decoder = JsonDecoder.fromString(jsonString);
    final config = ProjectsConfig.fromJson(decoder);

    for (var projectConfig in config.projects) {
      projects.create(ProjectFields(
        name: projectConfig.name,
        repoOwner: projectConfig.repoOwner,
        repoName: projectConfig.repoName,
        apiKey: projectConfig.apiKey ?? config.defaultApiKey ?? "",
      ));
    }
  }
}
