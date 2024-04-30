import 'package:prelude/prelude.dart';

import 'project_record.dart';

enum ProjectPersistenceError {
  notFound,
  nameTooShort,
  nameAlreadyUsed,
}

typedef ProjectPersistenceResult = FutureResult<ProjectRecord, ProjectPersistenceError>;

final class ProjectsRepo {
  var _records = List<ProjectRecord>.empty(growable: true);

  ProjectPersistenceError? _validate(ProjectFields fields) {
    if (fields.name.length < 3) {
      return ProjectPersistenceError.nameTooShort;
    }
    return null;
  }

  ProjectPersistenceResult tryCreate(ProjectFields fields) async {
    final validationErr = _validate(fields);
    if (validationErr != null) {
      return Err(validationErr);
    }

    final existing = await tryFindByName(fields.name);
    if (existing != null) {
      return const Err(ProjectPersistenceError.nameAlreadyUsed);
    }

    final record = ProjectRecord.fromFields(fields);
    _records.add(record);

    return Ok(record);
  }

  Future<Iterable<ProjectRecord>> findAll() async => //
      _records.unmodifiable();

  Future<ProjectRecord?> tryFind(UUID id) async => //
      _records.where((it) => it.id == id).firstOrNull;

  Future<ProjectRecord?> tryFindByName(String name) async => //
      _records.where((it) => it.name == name).firstOrNull;

  ProjectPersistenceResult tryUpdate(UUID id, ProjectFields fields) async {
    final validationErr = _validate(fields);
    if (validationErr != null) {
      return Err(validationErr);
    }

    final existing = await tryFindByName(fields.name);
    if (existing != null && existing.id != id) {
      return const Err(ProjectPersistenceError.nameAlreadyUsed);
    }

    final record = ProjectRecord.fromFields(fields, id: id);

    var found = false;

    _records = _records.map((it) {
      if (it.id == id) {
        found = true;
        return record;
      }

      return it;
    }).toList();

    return found ? Ok(record) : const Err(ProjectPersistenceError.notFound);
  }

  Future<void> delete(UUID id) async {
    _records = _records.where((it) => it.id != id).toList();
  }
}
