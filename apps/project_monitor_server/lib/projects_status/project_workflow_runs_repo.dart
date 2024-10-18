import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects_status/project_workflow_run.dart';

final class ProjectWorkflowRunsRepo {
  final _records = List<ProjectWorkflowRun>.empty(growable: true);

  Future<ProjectWorkflowRun> save(ProjectWorkflowRun record) async {
    _records.add(record);
    return record;
  }

  Future<Iterable<ProjectWorkflowRun>> findAll() async => //
      _records.unmodifiable();
}
