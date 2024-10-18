import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_monitor_server/projects/project_record.dart';

part 'project_workflow_run.freezed.dart';

enum ProjectWorkflowRunStatus {
  completed,
  unknown,
  inProgress,
}

@freezed
class ProjectWorkflowRun with _$ProjectWorkflowRun {
  const factory ProjectWorkflowRun({
    required ProjectRecord project,
    required int id,
    required String name,
    required ProjectWorkflowRunStatus status,
    required String url,
    required String branch,
  }) = _ProjectWorkflowRun;
}
