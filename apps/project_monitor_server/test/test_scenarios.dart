import 'package:project_monitor_server/projects/project_record.dart';

import 'test_app_server.dart';

extension TestScenarios on TestAppServer {
  Future<ProjectRecord> loadProject({
    String? name,
    String? repoOwner,
    String? repoName,
    String? apiKey,
  }) {
    final repo = dependencies.projects;

    final fields = ProjectFields(
      name: name ?? 'Some Project',
      repoOwner: repoOwner ?? 'some-owner',
      repoName: repoName ?? 'some-project',
      apiKey: apiKey ?? 'some-api-key',
    );

    return repo.create(fields);
  }

  Future<List<ProjectRecord>> loadSomeProjects() async {
    return [
      (await loadProject(name: 'Project #0', repoOwner: 'org-A', repoName: 'project-0')),
      (await loadProject(name: 'Project #1', repoOwner: 'org-B', repoName: 'project-1')),
    ];
  }
}
