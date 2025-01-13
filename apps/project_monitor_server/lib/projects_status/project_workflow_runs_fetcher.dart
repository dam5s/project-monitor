import 'package:async_support/async_support.dart';
import 'package:http/http.dart';
import 'package:networking_support/networking_support.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects_status/project_workflow_run.dart';

extension ProjectWorkflowRunsFetcher on Client {
  HttpFuture<Iterable<ProjectWorkflowRun>> fetchProjectWorkflowRuns(
    String githubApiUrl,
    ProjectRecord project,
  ) async {
    final apiPath = '/repos/${project.repoOwner}/${project.repoName}/actions/runs';
    final url = Uri.parse('$githubApiUrl$apiPath');

    final httpResult = await sendRequest(HttpMethod.get, url, headers: {
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer ${project.apiKey}',
    });

    return httpResult.tryParseJson(
      (d) => d.objectArray(
        'workflow_runs',
        (d) => ProjectWorkflowRun(
          project: project,
          id: d.field('id'),
          name: d.field('name'),
          status: _statusFromString(d.field('status')),
          branch: d.field('head_branch'),
          url: d.field('url'),
        ),
      ),
      async: IsolateAsyncCompute(),
    );
  }
}

ProjectWorkflowRunStatus _statusFromString(String value) => //
    switch (value) {
      'completed' => ProjectWorkflowRunStatus.completed,
      'in_progress' => ProjectWorkflowRunStatus.inProgress,
      _ => ProjectWorkflowRunStatus.unknown,
    };
