import 'dart:convert';

import 'package:project_monitor_server/projects/projects_repo.dart';
import 'package:project_monitor_server/shelf_support/responses.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Handler> buildProjectsHandler(ProjectsRepo repo) async {
  final router = Router()
    ..get('/', (request) {
      return Responses.json({'projects': []});
    })
    ..get('/<id>', (request, String id) {
      // show
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
