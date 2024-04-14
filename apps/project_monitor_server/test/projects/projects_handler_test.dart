import 'dart:io';

import 'package:http_support/http_support.dart';
import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:test/test.dart';

import '../test_server.dart';

extension TestScenarios on TestServer {
  Future<List<ProjectRecord>> loadSomeProjects() async {
    final repo = dependencies.projects;
    return [
      await repo.create(ProjectFields(name: 'Project #0')),
      await repo.create(ProjectFields(name: 'Project #1')),
    ];
  }
}

void main() {
  late TestServer server;

  setUp(() async {
    server = await TestServer.start();
  });

  tearDown(() async {
    await server.close();
  });

  test('GET /projects', () async {
    final projects = await server.loadSomeProjects();

    final response = await server.request(HttpMethod.get, '/projects');

    final expectedJson = '{"projects":['
      '{"id":"${projects[0].id.value}","name":"Project #0"},'
      '{"id":"${projects[1].id.value}","name":"Project #1"}'
      ']}';

    expect(response?.statusCode, equals(HttpStatus.ok));
    expect(response?.body, equals(expectedJson));
    expect(response?.headers['content-type'], equals('application/json'));
  });

  test('GET /projects/<id>', () async {
    final projects = await server.loadSomeProjects();

    final response = await server.request(HttpMethod.get, '/projects/${projects[0].id.value}');

    final expectedJson = '{"id":"${projects[0].id.value}","name":"Project #0"}';

    expect(response?.statusCode, equals(HttpStatus.ok));
    expect(response?.body, equals(expectedJson));
    expect(response?.headers['content-type'], equals('application/json'));
  });

  test('GET /projects/<id> when id is not a UUID', () async {
    final response = await server.request(HttpMethod.get, '/projects/not-a-uuid');

    expect(response?.statusCode, equals(HttpStatus.notFound));
  });

  test('GET /projects/<id> when no record match the id', () async {
    final someId = UUID.v4();

    final response = await server.request(HttpMethod.get, '/projects/${someId.value}');

    expect(response?.statusCode, equals(HttpStatus.notFound));
  });
}
