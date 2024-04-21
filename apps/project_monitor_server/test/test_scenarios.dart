import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/project_record.dart';

import 'test_server.dart';

extension TestScenarios on TestServer {

  Future<ProjectRecord> loadProject({String? name}) async {
    final repo = dependencies.projects;
    final fields = ProjectFields(name: name ?? 'Some Project');

    return (await repo.tryCreate(fields)).orThrow();
  }

  Future<List<ProjectRecord>> loadSomeProjects() async {
    return [
      (await loadProject(name: 'Project #0')),
      (await loadProject(name: 'Project #1')),
    ];
  }
}
