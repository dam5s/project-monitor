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

    expect(response.statusCode, equals(HttpStatus.ok));
    expect(response.body, equals(expectedJson));
    expect(response.headers['content-type'], equals('application/json'));
  });

  group('GET /projects/<id>', () {
    test('happy path', () async {
      final projects = await server.loadSomeProjects();
      final project0 = projects[0];

      final response = await server.get('/projects/${project0.id.value}');

      final expectedJson = '{"id":"${project0.id.value}","name":"Project #0"}';

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.body, equals(expectedJson));
      expect(response.headers['content-type'], equals('application/json'));
    });

    test('when id is not a UUID', () async {
      final response = await server.get('/projects/not-a-uuid');

      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('when no record match the id', () async {
      final someId = UUID.v4();

      final response = await server.get('/projects/${someId.value}');

      expect(response.statusCode, equals(HttpStatus.notFound));
    });
  });

  group('POST /projects', () {
    test('happy path', () async {
      final response = await server.post('/projects', body: {'name': 'My Project'});

      expect(response.statusCode, equals(HttpStatus.created));
      expect(response.headers['content-type'], equals('application/json'));

      final responseJson = jsonDecode(response.body ?? '');
      expect(responseJson['id'], isUUIDString());
      expect(responseJson['name'], equals('My Project'));

      final createdId = UUID.tryFromString(responseJson['id'] as String)!;

      final expectedJson = '{"id":"${createdId.value}","name":"My Project"}';
      final getResponse = await server.get('/projects/${createdId.value}');
      expect(getResponse.statusCode, equals(HttpStatus.ok));
      expect(getResponse.body, equals(expectedJson));
    });

    test('with invalid json', () async {
      final response = await server.post('/projects', body: 'nope');

      expect(response.statusCode, equals(HttpStatus.badRequest));

      final allProjects = await repo.findAll();
      expect(allProjects.length, equals(0));
    });

    test('when persistence fails', () async {
      await server.loadSomeProjects();

      final response = await server.post('/projects', body: {'name': 'Project #0'});

      final allProjects = await repo.findAll();
      expect(allProjects.length, equals(2));
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });

  group('PUT /projects/<id>', () {
    test('happy path', () async {
      final projects = await server.loadSomeProjects();
      final project0 = projects[0];
      final project1 = projects[1];

      final response = await server.put(
        '/projects/${project0.id.value}',
        body: {'name': 'My Updated Project'},
      );

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.headers['content-type'], equals('application/json'));

      final expectedJson = '{"id":"${project0.id.value}","name":"My Updated Project"}';
      expect(response.body, equals(expectedJson));

      final project0GetResponse = await server.get('/projects/${project0.id.value}');
      expect(project0GetResponse.body, equals(expectedJson));

      final project1GetResponse = await server.get('/projects/${project1.id.value}');
      expect(jsonDecode(project1GetResponse.body ?? '')['name'], equals('Project #1'));
    });

    test('when uuid is invalid', () async {
      final response = await server.put(
        '/projects/not-quite-right',
        body: {'name': 'My Updated Project'},
      );

      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('when project not found', () async {
      final response = await server.put(
        '/projects/9866bea2-5ffe-4e26-9b19-a74ac6d74c3c',
        body: {'name': 'My Updated Project'},
      );

      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('when name already in use', () async {
      final projects = await server.loadSomeProjects();
      final project0 = projects[0];
      final project1 = projects[1];

      final response = await server.put(
        '/projects/${project0.id.value}',
        body: {'name': 'Project #1'},
      );
      expect(response.statusCode, equals(HttpStatus.badRequest));

      final project0GetResponse = await server.get('/projects/${project0.id.value}');
      expect(jsonDecode(project0GetResponse.body ?? '')['name'], equals('Project #0'));

      final project1GetResponse = await server.get('/projects/${project1.id.value}');
      expect(jsonDecode(project1GetResponse.body ?? '')['name'], equals('Project #1'));
    });

    test('when updating with the same name', () async {
      final projects = await server.loadSomeProjects();
      final project0 = projects[0];

      final response = await server.put(
        '/projects/${project0.id.value}',
        body: {'name': 'Project #0'},
      );

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.headers['content-type'], equals('application/json'));

      final expectedJson = '{"id":"${project0.id.value}","name":"Project #0"}';
      expect(response.body, equals(expectedJson));
    });
  });

  group('DELETE /projects/<id>', () {
    test('happy path', () async {
      final projects = await server.loadSomeProjects();
      final project0 = projects[0];
      final project1 = projects[1];

      final response = await server.delete('/projects/${project0.id.value}');

      expect(response.statusCode, equals(HttpStatus.noContent));

      final project0GetResponse = await server.get('/projects/${project0.id.value}');
      expect(project0GetResponse.statusCode, equals(HttpStatus.notFound));

      final project1GetResponse = await server.get('/projects/${project1.id.value}');
      expect(project1GetResponse.statusCode, equals(HttpStatus.ok));
    });

    test('with invalid uuid', () async {
      final projects = await server.loadSomeProjects();
      final project0 = projects[0];
      final project1 = projects[1];

      final response = await server.delete('/projects/not-quite-right');

      expect(response.statusCode, equals(HttpStatus.noContent));

      final project0GetResponse = await server.get('/projects/${project0.id.value}');
      expect(project0GetResponse.statusCode, equals(HttpStatus.ok));

      final project1GetResponse = await server.get('/projects/${project1.id.value}');
      expect(project1GetResponse.statusCode, equals(HttpStatus.ok));
    });

    test('with non-existent uuid', () async {
      final projects = await server.loadSomeProjects();
      final project0 = projects[0];
      final project1 = projects[1];

      final response = await server.delete('/projects/9866bea2-5ffe-4e26-9b19-a74ac6d74c3c');

      expect(response.statusCode, equals(HttpStatus.noContent));

      final project0GetResponse = await server.get('/projects/${project0.id.value}');
      expect(project0GetResponse.statusCode, equals(HttpStatus.ok));

      final project1GetResponse = await server.get('/projects/${project1.id.value}');
      expect(project1GetResponse.statusCode, equals(HttpStatus.ok));
    });
  });
}
