import 'dart:io';

import 'package:project_monitor_server/app_dependencies.dart';
import 'package:project_monitor_server/app_server.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

Future<HttpServer> _startServer() async {
  final dependencies = AppDependencies.shared;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;

  final server = await buildAppServer(dependencies, port: port);

  print('Serving at http://${server.address.host}:${server.port}');

  return server;
}

Future<void> main() async {
  final useHotreload = Platform.environment['USE_HOTRELOAD'] == 'true';

  if (useHotreload) {
    withHotreload(() => _startServer());
  } else {
    await _startServer();
  }
}
