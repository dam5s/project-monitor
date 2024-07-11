import 'package:prelude/prelude.dart';

import 'project_record.dart';

final class ProjectsRepo {
  final UUID Function() idGenerator;

  ProjectsRepo({UUID Function()? uuidGenerator}) : this.idGenerator = uuidGenerator ?? UUID.v4;

  var _records = List<ProjectRecord>.empty(growable: true);

  Future<ProjectRecord> create(ProjectFields fields) async {
    final record = ProjectRecord.fromFields(fields, id: idGenerator());
    _records.add(record);
    return record;
  }

  Future<Iterable<ProjectRecord>> findAll() async => //
      _records.unmodifiable();

  Future<ProjectRecord?> tryFind(UUID id) async => //
      _records.where((it) => it.id == id).firstOrNull;
}
