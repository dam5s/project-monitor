import 'package:async_support/async_support.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/projects_config/projects_config_loader.dart';
import 'package:project_monitor_server/projects_status/project_workflow_runs_repo.dart';
import 'package:project_monitor_server/projects_status/projects_status_updater.dart';

final class AppDependencies {
  final ProjectsRepo projects;
  final PeriodicRunner runner;
  final ProjectsConfigLoader loader;
  final ProjectWorkflowRunsRepo workflowRuns;
  final ProjectsStatusUpdater updater;

  AppDependencies({
    required this.projects,
    required this.runner,
    required this.loader,
    required this.workflowRuns,
    required this.updater,
  });

  static final shared = AppDependencies.defaults();

  factory AppDependencies.defaults() {
    final projectsRepo = ProjectsRepo();
    final workflowRunsRepo = ProjectWorkflowRunsRepo();

    return AppDependencies(
      projects: projectsRepo,
      runner: PeriodicRunner(),
      loader: ProjectsConfigLoader(projects: projectsRepo),
      workflowRuns: workflowRunsRepo,
      updater: ProjectsStatusUpdater(projects: projectsRepo, workflowRuns: workflowRunsRepo),
    );
  }
}
