import 'dart:async';
import 'dart:io';

import 'package:http_support/http_support.dart';
import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/shelf_support/json_parsing.dart';
import 'package:project_monitor_server/shelf_support/responses.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

dynamic _projectJson(ProjectRecord project) => {'id': project.id.value, 'name': project.name};

ProjectFields _decodeFields(JsonDecoder decoder) => ProjectFields(name: decoder.field('name'));

Future<Response> _listProjects(ProjectsRepo repo, Request request) async {
  final projects = await repo.findAll();
  final projectsJson = {'projects': projects.map(_projectJson).toList()};

  return Responses.json(projectsJson);
}

Future<Response> _showProject(ProjectsRepo repo, Request request, String id) async {
  final projectId = UUID.tryFromString(id);
  if (projectId == null) {
    return Response.notFound(null);
  }

  final project = await repo.tryFind(projectId);
  if (project == null) {
    return Response.notFound(null);
  }

  return Responses.json(_projectJson(project));
}

Future<Response> _createProject(ProjectsRepo repo, Request request) async {
  return request
      .tryParse(_decodeFields)
      .flatMapOk((fields) => repo.tryCreate(fields))
      .mapOk((record) => Responses.json(_projectJson(record), code: HttpStatus.created))
      .orElse((error) => Responses.json({'error': error}, code: HttpStatus.badRequest));
}

FutureOr<Response> _updateErrorResponse(String error) {
  if (error == 'Not found') {
    return Response.notFound(null);
  } else {
    return Responses.json({'error': error}, code: HttpStatus.badRequest);
  }
}

Future<Response> _updateProject(ProjectsRepo repo, Request request, String id) async {
  final projectId = UUID.tryFromString(id);
  if (projectId == null) {
    return Response.notFound(null);
  }

  return request
      .tryParse(_decodeFields)
      .flatMapOk((fields) => repo.tryUpdate(projectId, fields))
      .mapOk((record) => Responses.json(_projectJson(record), code: HttpStatus.ok))
      .orElse(_updateErrorResponse);
}

Future<Response> _deleteProject(ProjectsRepo repo, Request request, String id) async {
  final projectId = UUID.tryFromString(id);

  if (projectId != null) {
    repo.delete(projectId);
  }

  return Response(HttpStatus.noContent);
}

Handler projectsHandler(ProjectsRepo repo) {
  final router = Router()
    ..get('/', (Request request) => _listProjects(repo, request))
    ..get('/<id>', (Request request, String id) => _showProject(repo, request, id))
    ..post('/', (Request request) => _createProject(repo, request))
    ..put('/<id>', (Request request, String id) => _updateProject(repo, request, id))
    ..delete('/<id>', (Request request, String id) => _deleteProject(repo, request, id));

  return router.call;
}
