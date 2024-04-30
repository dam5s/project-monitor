import 'package:project_monitor_server/projects/projects_repo.dart';

final class AppDependencies {
  final ProjectsRepo projects;

  AppDependencies({required this.projects});

  static final shared = AppDependencies.defaults();

  factory AppDependencies.defaults() {
    return AppDependencies(projects: ProjectsRepo());
  }
}
