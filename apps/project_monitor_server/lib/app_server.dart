import 'package:grpc/grpc.dart';
import 'package:project_monitor_server/projects/projects_api_service.dart';

import 'app_dependencies.dart';

Future<Server> startAppServer(
  AppDependencies dependencies, {
  required int port,
}) async {
  final server = Server.create(
    services: [
      ProjectsApiService(projects: dependencies.projects),
    ],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );

  await server.serve(port: port);

  return server;
}
