import 'package:prelude/prelude.dart';

import 'project_record.dart';

sealed class ProjectPersistenceError {}

final class ProjectNameUniquenessViolation implements ProjectPersistenceError {
  final ProjectRecord existing;

  ProjectNameUniquenessViolation(this.existing);
}

final class ProjectsRepo {
  var _records = List<ProjectRecord>.empty(growable: true);

  Future<Result<ProjectRecord, ProjectPersistenceError>> create(ProjectFields fields) async {
    final existing = await tryFindByName(fields.name);
    if (existing != null) {
      return Err(ProjectNameUniquenessViolation(existing));
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

  Future<ProjectRecord?> tryUpdate(UUID id, ProjectFields fields) async {
    final record = ProjectRecord.fromFields(fields, id: id);

    var found = false;

    _records = _records.map((it) {
      if (it.id == id) {
        found = true;
        return record;
      }

      return it;
    }).toList();

    return found ? record : null;
  }

  Future<void> delete(UUID id) async {
    _records = _records.where((it) => it.id != id).toList();
  }
}
