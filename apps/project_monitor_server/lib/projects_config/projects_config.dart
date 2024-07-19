import 'package:networking_support/networking_support.dart';

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

  factory ProjectsConfig.fromJson(JsonDecoder decoder) => //
      ProjectsConfig(
        defaultApiKey: decoder.field('defaultApiKey'),
        projects: decoder.objectArray('projects', decodeProjectFields),
      );
}

ProjectConfig decodeProjectFields(JsonDecoder decoder) => //
    ProjectConfig(
      name: decoder.field('name'),
      repoOwner: decoder.field('repoOwner'),
      repoName: decoder.field('repoName'),
      apiKey: decoder.optionalField('apiKey'),
    );
