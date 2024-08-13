import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/src/client.dart';
import 'package:networking_support/networking_support.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';

part 'projects_status_updater.freezed.dart';

enum ProjectWorkflowRunStatus {
  Completed,
  Unknown,
  InProgress,
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

class ProjectsStatusUpdater {
  final ProjectsRepo projects;
  final String githubApiUrl;
  final HttpClientProvider clientProvider = ConcreteHttpClientProvider();

  ProjectsStatusUpdater({required this.projects, String? githubApiUrl})
      : this.githubApiUrl = githubApiUrl ?? 'https://api.github.com';

  Future<Iterable<ProjectWorkflowRun>> run() async {
    return clientProvider.withHttpClient((client) async {
      final allProjects = await projects.findAll();
      final allRuns = List<ProjectWorkflowRun>.empty(growable: true);

      for (var project in allProjects) {
        final projectRuns = await _fetchProjectWorkflowRuns(project, client);
        allRuns.addAll(projectRuns);
      }

      return allRuns;
    });
  }

  Future<Iterable<ProjectWorkflowRun>> _fetchProjectWorkflowRuns(
      ProjectRecord project, Client client) async {
    final repoRunsUrl =
        Uri.parse('${githubApiUrl}/repos/${project.repoOwner}/${project.repoName}/actions/runs');

    final response = await client.get(repoRunsUrl, headers: {
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer ${project.apiKey}',
    });

    final decoder = JsonDecoder.fromString(response.body);

    return decoder.objectArray(
        'workflow_runs',
        (d) => ProjectWorkflowRun(
              project: project,
              id: d.field('id'),
              name: d.field('name'),
              status: _statusFromString(d.field('status')),
              branch: d.field('head_branch'),
              url: d.field('url'),
            ));
  }

  ProjectWorkflowRunStatus _statusFromString(String value) => //
      switch (value) {
        'completed' => ProjectWorkflowRunStatus.Completed,
        'in_progress' => ProjectWorkflowRunStatus.InProgress,
        _ => ProjectWorkflowRunStatus.Unknown,
      };
}
