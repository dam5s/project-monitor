import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
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
    final createdProjects = [
      await projects.create(
        ProjectFields(
          name: 'My Project #1',
          repoOwner: 'dam5s',
          repoName: 'my-project',
          apiKey: 'some-api-key',
        ),
      ),
      await projects.create(
        ProjectFields(
          name: 'My Project #2',
          repoOwner: 'dam5s',
          repoName: 'my-project-2',
          apiKey: 'some-other-api-key',
        ),
      )
    ];

    server.stubWorkflowRun(StubbedWorkflowRun(
      project: createdProjects[0],
      id: 100100,
      name: 'Build app',
      head_branch: 'master',
      status: 'completed',
      url: 'https://api.github.com/repos/dam5s/my-project/actions/runs/100100',
    ));
    server.stubWorkflowRun(StubbedWorkflowRun(
      project: createdProjects[1],
      id: 100200,
      name: 'Build app #2',
      head_branch: 'main',
      status: 'completed',
      url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100200',
    ));
    server.stubWorkflowRun(StubbedWorkflowRun(
      project: createdProjects[1],
      id: 100201,
      name: 'Deploy app #2',
      head_branch: 'main',
      status: 'in_progress',
      url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100201',
    ));

    final updater = ProjectsStatusUpdater(projects: projects, githubApiUrl: server.url());
    final workflowRuns = await updater.run();

    expect(workflowRuns.length, equals(3));
    final workflowRunsList = workflowRuns.toList();
    expect(
        workflowRunsList[0],
        equals(ProjectWorkflowRun(
          project: createdProjects[0],
          id: 100100,
          name: 'Build app',
          status: ProjectWorkflowRunStatus.Completed,
          branch: 'master',
          url: 'https://api.github.com/repos/dam5s/my-project/actions/runs/100100',
        )),
    );
    expect(
        workflowRunsList[1],
        equals(ProjectWorkflowRun(
          project: createdProjects[1],
          id: 100200,
          name: 'Build app #2',
          status: ProjectWorkflowRunStatus.Completed,
          branch: 'main',
          url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100200',
        )),
    );
    expect(
        workflowRunsList[2],
        equals(ProjectWorkflowRun(
          project: createdProjects[1],
          id: 100201,
          name: 'Deploy app #2',
          status: ProjectWorkflowRunStatus.InProgress,
          branch: 'main',
          url: 'https://api.github.com/repos/dam5s/my-project-2/actions/runs/100201',
        )),
    );

    expect(server.recordedRequest?.headers['Accept'], equals('application/vnd.github+json'));
    expect(server.recordedRequest?.headers['Authorization'], equals('Bearer some-other-api-key'));
  });
}
