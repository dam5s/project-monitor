import 'dart:io';

import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/shelf_support/responses.dart';
import 'package:shelf/shelf.dart';

import 'project_record.dart';
import 'projects_repo.dart';

dynamic _projectJson(ProjectRecord project) => {'id': project.id.value, 'name': project.name};

Response projectResponse(ProjectRecord? project, {int? successCode}) {
  return project == null
      ? Responses.json({'error': 'Project not found'}, code: HttpStatus.notFound)
      : Responses.json(_projectJson(project), code: successCode ?? HttpStatus.ok);
}

Response projectListResponse(Iterable<ProjectRecord> projects) {
  return Responses.json({'projects': projects.map(_projectJson).toList()});
}

Response projectErrorResponse(String error) {
  return Responses.json({'error': error}, code: HttpStatus.badRequest);
}

extension ProjectPersistenceResponse on ProjectPersistenceResult {
  Future<Response> toResponse({int? successCode}) async => switch (await this) {
        Ok(value: final record) => projectResponse(record, successCode: successCode),
        Err(error: ProjectPersistenceError.notFound) => projectResponse(null),
        Err(error: ProjectPersistenceError.nameTooShort) => projectErrorResponse('Name too short'),
        Err(error: ProjectPersistenceError.nameAlreadyUsed) => projectErrorResponse('Name already used'),
      };
}
