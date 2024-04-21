import 'package:project_monitor_server/projects/projects_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'app_dependencies.dart';

Future<Handler> appHandler(AppDependencies dependencies) async {
  final router = Router();
  router.mount("/projects", projectsHandler(dependencies.projects));

  return const Pipeline() //
      .addMiddleware(logRequests())
      .addHandler(router.call);
}
