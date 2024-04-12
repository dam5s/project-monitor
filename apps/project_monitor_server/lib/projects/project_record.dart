import 'package:prelude/prelude.dart';

final class ProjectFields {
  final String name;

  ProjectFields({required this.name});
}

final class ProjectRecord extends ProjectFields {
  final UUID id;

  ProjectRecord({required this.id, required super.name});

  factory ProjectRecord.fromFields(ProjectFields fields, {UUID? id}) {
    return ProjectRecord(
      id: id ?? UUID.v4(),
      name: fields.name,
    );
  }
}
