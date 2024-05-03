import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/project_record.dart';

import 'test_server.dart';

extension TestScenarios on TestServer {
  Future<ProjectRecord> loadProject({String? name, String? repoOwner, String? repoName}) async {
    final repo = dependencies.projects;
    final fields = ProjectFields(
      name: name ?? 'Some Project',
      repoOwner: repoOwner ?? 'some-owner',
      repoName: repoName ?? 'some-project',
    );

    return (await repo.tryCreate(fields)).orThrow();
  }

  Future<List<ProjectRecord>> loadSomeProjects() async {
    return [
      (await loadProject(name: 'Project #0', repoOwner: 'org-A', repoName: 'project-0')),
      (await loadProject(name: 'Project #1', repoOwner: 'org-B', repoName: 'project-1')),
    ];
  }
}
