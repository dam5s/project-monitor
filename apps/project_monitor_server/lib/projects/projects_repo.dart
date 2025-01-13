import 'package:prelude/prelude.dart';

import 'project_record.dart';

final class ProjectsRepo {
  final UUID Function() idGenerator;

  ProjectsRepo({UUID Function()? uuidGenerator}) : idGenerator = uuidGenerator ?? UUID.v4;

  final _records = List<ProjectRecord>.empty(growable: true);

  Future<ProjectRecord> create(ProjectFields fields) async {
    final record = ProjectRecord.fromFields(fields, id: idGenerator());
    _records.add(record);
    return record;
  }

  Future<Iterable<ProjectRecord>> findAll() async => //
      _records.unmodifiable();
}
