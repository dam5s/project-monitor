import 'package:logging/logging.dart';
import 'package:prelude/prelude.dart';
import 'package:async_support/async_support.dart';
import 'package:http/http.dart';
import 'package:networking_support/networking_support.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';

import 'project_workflow_run.dart';
import 'project_workflow_runs_repo.dart';

class ProjectsStatusUpdater {
  final ProjectsRepo projects;
  final ProjectWorkflowRunsRepo workflowRuns;
  final String githubApiUrl;
  final HttpClientProvider clientProvider = ConcreteHttpClientProvider();

  final Logger _logger = Logger('ProjectsStatusUpdater');

  ProjectsStatusUpdater({required this.projects, required this.workflowRuns, String? githubApiUrl})
      : githubApiUrl = githubApiUrl ?? 'https://api.github.com';

  Future<void> run() async {
    _logger.info('Running updater');
    await clientProvider.withHttpClient(_fetchAllRuns);
  }

  Future<void> _fetchAllRuns(Client client) async {
    final allProjects = await projects.findAll();

    for (final project in allProjects) {
      final url = '$githubApiUrl/repos/${project.repoOwner}/${project.repoName}/actions/runs';

      final response = await client.sendRequest(HttpMethod.get, Uri.parse(url), headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer ${project.apiKey}'
      });

      final parseResult =
          await response.tryParseJson(decodeWorkflowRunList(project), async: IsolateAsyncCompute());

      switch (parseResult) {
        case Ok(value: final workflowRunList):
          await Future.wait(workflowRunList.map(workflowRuns.save));
        case Err(:final error):
        // TODO log this
      }
    }
  }

  JsonDecode<Iterable<ProjectWorkflowRun>> decodeWorkflowRunList(ProjectRecord project) =>
      (json) => //
          json.objectArray('workflow_runs', decodeSingleWorkflowRun(project));

  JsonDecode<ProjectWorkflowRun> decodeSingleWorkflowRun(ProjectRecord project) => (json) => //
      ProjectWorkflowRun(
        project: project,
        id: json.field('id'),
        name: json.field('name'),
        status: json.field('status', map: decodeStatus),
        url: json.field('url'),
        branch: json.field('head_branch'),
      );

  ProjectWorkflowRunStatus decodeStatus(dynamic value) {
    return switch (value) {
      'completed' => ProjectWorkflowRunStatus.completed,
      'in_progress' => ProjectWorkflowRunStatus.inProgress,
      _ => ProjectWorkflowRunStatus.unknown,
    };
  }
}
