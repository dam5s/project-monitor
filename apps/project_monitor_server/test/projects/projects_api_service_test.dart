import 'package:projects_api/projects_api.pbgrpc.dart';
import 'package:test/test.dart';

import '../test_scenarios.dart';
import '../test_server.dart';

void main() {
  late TestServer server;
  late ProjectsApiClient client;

  setUp(() async {
    server = await TestServer.start();
    client = server.projectsApiClient();
  });

  tearDown(() async {
    await server.close();
  });

  group('listProjects', () {
    test('with no projects', () async {
      final response = await client.listProjects(ListProjectsRequest());

      expect(response.projects.length, equals(0));
    });

    test('with some projects', () async {
      await server.loadSomeProjects();

      final response = await client.listProjects(ListProjectsRequest());

      expect(response.projects.length, equals(2));
      expect(response.projects[0].name, equals('Project #0'));
      expect(response.projects[0].status, equals(ProjectStatus.Unknown));
      expect(response.projects[1].name, equals('Project #1'));
      expect(response.projects[1].status, equals(ProjectStatus.Unknown));
    });
  });
}
