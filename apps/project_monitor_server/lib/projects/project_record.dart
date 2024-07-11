import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prelude/prelude.dart';

part 'project_record.freezed.dart';

@freezed
class ProjectFields with _$ProjectFields {
  const factory ProjectFields({
    required String name,
    required String repoOwner,
    required String repoName,
    required String apiKey,
  }) = _ProjectFields;
}

@freezed
class ProjectRecord with _$ProjectRecord {
  const factory ProjectRecord({
    required UUID id,
    required String name,
    required String repoOwner,
    required String repoName,
    required String apiKey,
  }) = _ProjectRecord;

  factory ProjectRecord.fromFields(ProjectFields fields, {required UUID id}) => ProjectRecord(
        id: id,
        name: fields.name,
        repoOwner: fields.repoOwner,
        repoName: fields.repoName,
        apiKey: fields.apiKey,
      );
}
