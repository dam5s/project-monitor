import 'dart:convert';
import 'dart:io';

import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:test/test.dart';

import '../test_matchers.dart';
import '../test_scenarios.dart';
import '../test_server.dart';


void main() {
  late TestServer server;
  late ProjectsRepo repo;

  setUp(() async {
    server = await TestServer.start();
    repo = server.dependencies.projects;
  });

  tearDown(() async {
    await server.close();
  });

  test('GET /projects', () async {
    final projects = await server.loadSomeProjects();

    final response = await server.get('/projects');

    final expectedJson = '{"projects":['
        '{"id":"${projects[0].id.value}","name":"Project #0"},'
        '{"id":"${projects[1].id.value}","name":"Project #1"}'
        ']}';

    expect(response?.statusCode, equals(HttpStatus.ok));
    expect(response?.body, equals(expectedJson));
    expect(response?.headers['content-type'], equals('application/json'));
  });

  group('GET /projects/<id>', () {
    test('happy path', () async {
      final projects = await server.loadSomeProjects();

      final response = await server.get('/projects/${projects[0].id.value}');

      final expectedJson = '{"id":"${projects[0].id.value}","name":"Project #0"}';

      expect(response?.statusCode, equals(HttpStatus.ok));
      expect(response?.body, equals(expectedJson));
      expect(response?.headers['content-type'], equals('application/json'));
    });

    test('when id is not a UUID', () async {
      final response = await server.get('/projects/not-a-uuid');

      expect(response?.statusCode, equals(HttpStatus.notFound));
    });

    test('when no record match the id', () async {
      final someId = UUID.v4();

      final response = await server.get('/projects/${someId.value}');

      expect(response?.statusCode, equals(HttpStatus.notFound));
    });
  });

  group('POST /projects', () {
    test('happy path', () async {
      final createResponse = await server.post('/projects', body: {'name': 'My Project'});

      expect(createResponse?.statusCode, equals(HttpStatus.created));
      expect(createResponse?.headers['content-type'], equals('application/json'));

      final responseJson = jsonDecode(createResponse?.body ?? '');
      expect(responseJson['id'], isUUIDString());
      expect(responseJson['name'], equals('My Project'));

      final createdId = UUID.tryFromString(responseJson['id'] as String)!;

      final showResponse = await server.get('/projects/${createdId.value}');
      expect(showResponse?.statusCode, equals(HttpStatus.ok));

      final createdProject = await repo.tryFind(createdId);
      expect(createdProject?.id, createdId);
      expect(createdProject?.name, equals('My Project'));
    });

    test('with invalid json', () async {
      final createResponse = await server.post('/projects', body: 'nope');

      expect(createResponse?.statusCode, equals(HttpStatus.badRequest));

      final allProjects = await repo.findAll();
      expect(allProjects.length, equals(0));
    });

    test('when persistence fails', () async {
      server.loadSomeProjects();

      final createResponse = await server.post('/projects', body: {'name': 'Project #0'});

      final allProjects = await repo.findAll();
      expect(allProjects.length, equals(2));
      expect(createResponse?.statusCode, equals(HttpStatus.badRequest));
    });
  });
}
