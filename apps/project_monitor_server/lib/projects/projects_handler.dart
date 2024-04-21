import 'dart:io';

import 'package:http_support/http_support.dart';
import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/shelf_support/responses.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

dynamic _projectJson(ProjectRecord project) => {'id': project.id.value, 'name': project.name};

dynamic _listJson(Iterable<ProjectRecord> records) =>
    {'projects': records.map(_projectJson).toList()};

extension ProjectFieldsSerialization on ProjectFields {
  static ProjectFields fromJson(JsonDecoder decoder) {
    return ProjectFields(name: decoder.field('name'));
  }
}

extension RequestJson on Request {
  Future<Result<T, String>> tryParse<T>(JsonDecode<T> decode) async {
    try {
      final body = await readAsString();
      final decoder = JsonDecoder.fromString(body);
      return Ok(decode(decoder));
    } on TypeError catch (e) {
      return Err('Failed to parse json $e');
    }
  }
}

Future<Handler> buildProjectsHandler(ProjectsRepo repo) async {
  final router = Router()
    ..get('/', (Request request) async {
      final projects = await repo.findAll();
      return Responses.json(_listJson(projects));
    })
    ..get('/<id>', (Request request, String id) async {
      final projectId = UUID.tryFromString(id);
      if (projectId == null) {
        return Response.notFound(null);
      }

      final project = await repo.tryFind(projectId);
      if (project == null) {
        return Response.notFound(null);
      }

      return Responses.json(_projectJson(project));
    })
    ..post('/', (Request request) async {
      return request
          .tryParse(ProjectFieldsSerialization.fromJson)
          .flatMapOk((fields) => repo.tryCreate(fields))
          .mapOk((record) => Responses.json(_projectJson(record), code: HttpStatus.created))
          .orElse((error) => Responses.json({'error': error}, code: HttpStatus.badRequest));
    })
    ..put('/<id>', (request, String id) {
      // update
    })
    ..delete('/<id>', (request, String id) {
      // destroy
    });

  return router.call;
}
