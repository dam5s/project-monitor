import 'dart:io';

import 'package:networking_support/networking_support.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';

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

final class ProjectConfig {
  final String name;
  final String repoOwner;
  final String repoName;
  final String? apiKey;

  ProjectConfig({
    required this.name,
    required this.repoOwner,
    required this.repoName,
    required this.apiKey,
  });
}

final class ProjectsConfig {
  final String? defaultApiKey;
  final Iterable<ProjectConfig> projects;

  ProjectsConfig({this.defaultApiKey, required this.projects});

  factory ProjectsConfig.fromJson(JsonDecoder decoder) => ProjectsConfig(
        defaultApiKey: decoder.field("defaultApiKey"),
        projects: decoder.objectArray("projects", decodeProjectFields),
      );
}

ProjectConfig decodeProjectFields(JsonDecoder decoder) => ProjectConfig(
      name: decoder.field("name"),
      repoOwner: decoder.field("repoOwner"),
      repoName: decoder.field("repoName"),
      apiKey: decoder.optionalField("apiKey"),
    );
