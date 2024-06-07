import 'package:grpc/grpc.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:projects_api/projects_api.pbgrpc.dart';

class ProjectsApiService extends ProjectsApiServiceBase {
  final ProjectsRepo projects;

  ProjectsApiService({required this.projects});

  @override
  Future<ListProjectsResponse> listProjects(ServiceCall call, ListProjectsRequest request) async {
    final records = await projects.findAll();

    return ListProjectsResponse(
      projects: records.map(
        (record) => ProjectInfo(name: record.name, status: ProjectStatus.Unknown),
      ),
    );
  }
}
