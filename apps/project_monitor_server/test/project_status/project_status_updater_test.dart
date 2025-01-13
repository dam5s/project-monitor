import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/projects_status/project_workflow_run.dart';
import 'package:project_monitor_server/projects_status/project_workflow_runs_repo.dart';
import 'package:project_monitor_server/projects_status/projects_status_updater.dart';
import 'package:test/test.dart';

import '../test_github_server.dart';

void main() {
  late TestGithubServer server;

  setUp(() async {
    server = await TestGithubServer.start();
  });

  tearDown(() async {
    await server.close();
  });

  test('fetching some workflow runs', () async {
    final projects = ProjectsRepo();
    final workflowRuns = ProjectWorkflowRunsRepo();
    final updater = ProjectsStatusUpdater(
      projects: projects,
      workflowRuns: workflowRuns,
      githubApiUrl: server.url(),
    );

    final project1 = await projects.create(
      const ProjectFields(
        name: 'My Project #1',
        repoOwner: 'dam5s',
        repoName: 'my-project',
        apiKey: 'some-api-key',
      ),
    );
    final project2 = await projects.create(
      const ProjectFields(
        name: 'My Project #2',
        repoOwner: 'dam5s',
        repoName: 'my-project-2',
        apiKey: 'some-other-api-key',
      ),
    );

    server.stubWorkflowRun(StubbedWorkflowRun(
      project: project1,
      id: 100100,
      name: 'Build app',
      branch: 'master',
      status: 'completed',
      url: 'https://api.github.com/repos/dam5s/my-project/actions/runs/100100',
    ));
    server.stubWorkflowRun(StubbedWorkflowRun(
      project: project2,
      id: 100200,
      name: 'Build app #2',
      branch: 'main',
      status: 'completed',
      url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100200',
    ));
    server.stubWorkflowRun(StubbedWorkflowRun(
      project: project2,
      id: 100201,
      name: 'Deploy app #2',
      branch: 'main',
      status: 'in_progress',
      url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100201',
    ));

    await updater.run();

    expect(server.recordedRequests.length, equals(2));

    final project1Request = server.recordedRequests[0];
    expect(project1Request.headers['Accept'], equals('application/vnd.github+json'));
    expect(project1Request.headers['Authorization'], equals('Bearer some-api-key'));
    expect(project1Request.url.path, equals('repos/dam5s/my-project/actions/runs'));

    final project2Request = server.recordedRequests[1];
    expect(project2Request.headers['Accept'], equals('application/vnd.github+json'));
    expect(project2Request.headers['Authorization'], equals('Bearer some-other-api-key'));
    expect(project2Request.url.path, equals('repos/dam5s/my-project-2/actions/runs'));

    final savedWorkflowRuns = await workflowRuns.findAll().then((it) => it.toList());

    expect(savedWorkflowRuns.length, equals(3));
    expect(
      savedWorkflowRuns[0],
      equals(ProjectWorkflowRun(
        project: project1,
        id: 100100,
        name: 'Build app',
        status: ProjectWorkflowRunStatus.completed,
        branch: 'master',
        url: 'https://api.github.com/repos/dam5s/my-project/actions/runs/100100',
      )),
    );
    expect(
      savedWorkflowRuns[1],
      equals(ProjectWorkflowRun(
        project: project2,
        id: 100200,
        name: 'Build app #2',
        status: ProjectWorkflowRunStatus.completed,
        branch: 'main',
        url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100200',
      )),
    );
    expect(
      savedWorkflowRuns[2],
      equals(ProjectWorkflowRun(
        project: project2,
        id: 100201,
        name: 'Deploy app #2',
        status: ProjectWorkflowRunStatus.inProgress,
        branch: 'main',
        url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100201',
      )),
    );
  });
}
