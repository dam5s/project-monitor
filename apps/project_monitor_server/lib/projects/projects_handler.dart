import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/projects/project_record.dart';
import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/shelf_support/responses.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

dynamic _projectJson(ProjectRecord project) =>
    {'id': project.id.value, 'name': project.name};

dynamic _listJson(Iterable<ProjectRecord> records) =>
    {'projects': records.map(_projectJson).toList()};

Future<Handler> buildProjectsHandler(ProjectsRepo repo) async {
  final router = Router()
    ..get('/', (request) async {
      final projects = await repo.findAll();
      return Responses.json(_listJson(projects));
    })
    ..get('/<id>', (request, String id) async {
      final projectId = UUID.tryFromString(id);
      if (projectId == null) {
        return Response.notFound(null);
      }

      final project = await repo.tryFind(projectId);
      if (project == null) {
        return Response.notFound(null);
      }

      return Responses.json(_projectJson(project));
    })
    ..post('/', (request) {
      // create
    })
    ..put('/<id>', (request, String id) {
      // update
    })
    ..delete('/<id>', (request, String id) {
      // destroy
    });

  return router.call;
}
