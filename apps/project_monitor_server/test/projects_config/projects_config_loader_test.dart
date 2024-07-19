import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/projects_config/projects_config_loader.dart';
import 'package:test/test.dart';

class TestUUIDGen {
  final List<UUID> ids;
  var _nextIndex = 0;

  TestUUIDGen({required int size}) : ids = List.generate(size, (_) => UUID.v4());

  UUID generate() {
    final value = ids[_nextIndex % ids.length];
    _nextIndex++;
    return value;
  }
}

void main() {
  test('loadInitialProjects', () async {
    final uuidGen = TestUUIDGen(size: 2);
    final repo = new ProjectsRepo(uuidGenerator: uuidGen.generate);
    final loader = new ProjectsConfigLoader(projects: repo);

    await loader.load(filePath: 'test/projects_config/test_projects.json');

    final loadedProjects = await repo.findAll();

    expect(loadedProjects.length, equals(2));
    expect(
      loadedProjects,
      containsAll([
        ProjectRecord(
          id: uuidGen.ids[0],
          name: 'Project Monitor',
          repoOwner: 'dam5s',
          repoName: 'project-monitor',
          apiKey: 'some-project-key',
        ),
        ProjectRecord(
          id: uuidGen.ids[1],
          name: 'SoManyFeeds',
          repoOwner: 'dam5s',
          repoName: 'somanyfeeds.fs',
          apiKey: 'some-default-key',
        ),
      ]),
    );
  });
}
