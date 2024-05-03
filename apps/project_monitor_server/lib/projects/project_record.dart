import 'package:prelude/prelude.dart';

final class ProjectFields {
  final String name;
  final String repoOwner;
  final String repoName;

  ProjectFields({
    required this.name,
    required this.repoOwner,
    required this.repoName,
  });
}

final class ProjectRecord extends ProjectFields {
  final UUID id;

  ProjectRecord({
    required this.id,
    required super.name,
    required super.repoOwner,
    required super.repoName,
  });

  factory ProjectRecord.fromFields(ProjectFields fields, {UUID? id}) {
    return ProjectRecord(
      id: id ?? UUID.v4(),
      name: fields.name,
      repoName: fields.repoName,
      repoOwner: fields.repoOwner,
    );
  }
}
