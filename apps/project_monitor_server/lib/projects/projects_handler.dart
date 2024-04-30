import 'dart:async';
import 'dart:io';

import 'package:http_support/http_support.dart';
import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/shelf_support/json_parsing.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'project_record.dart';
import 'project_responses.dart';
import 'projects_repo.dart';

ProjectFields _decodeFields(JsonDecoder decoder) {
  return ProjectFields(name: decoder.field('name'));
}

Future<Response> _listProjectsHandler(ProjectsRepo repo, Request request) async {
  final projects = await repo.findAll();

  return projectListResponse(projects);
}

Future<Response> _getProjectHandler(ProjectsRepo repo, Request request, String id) async {
  final projectId = UUID.tryFromString(id);
  if (projectId == null) {
    return projectResponse(null);
  }

  final project = await repo.tryFind(projectId);

  return projectResponse(project);
}

Future<Response> _createProjectHandler(ProjectsRepo repo, Request request) async {
  return request //
      .tryDecode(_decodeFields)
      .continueWith(
        (fields) => repo.tryCreate(fields).toResponse(successCode: HttpStatus.created),
      );
}

Future<Response> _updateProjectHandler(ProjectsRepo repo, Request request, String id) async {
  final projectId = UUID.tryFromString(id);
  if (projectId == null) {
    return projectResponse(null);
  }

  return request
      .tryDecode(_decodeFields)
      .continueWith((fields) => repo.tryUpdate(projectId, fields).toResponse());
}

Future<Response> _deleteProjectHandler(ProjectsRepo repo, Request request, String id) async {
  final projectId = UUID.tryFromString(id);

  if (projectId != null) {
    repo.delete(projectId);
  }

  return Response(HttpStatus.noContent);
}

Handler projectsHandler(ProjectsRepo repo) {
  final router = Router()
    ..get('/', (Request request) => _listProjectsHandler(repo, request))
    ..get('/<id>', (Request request, String id) => _getProjectHandler(repo, request, id))
    ..post('/', (Request request) => _createProjectHandler(repo, request))
    ..put('/<id>', (Request request, String id) => _updateProjectHandler(repo, request, id))
    ..delete('/<id>', (Request request, String id) => _deleteProjectHandler(repo, request, id));

  return router.call;
}
