import 'dart:io';
import 'dart:developer';

import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';
import 'package:project_monitor_server/app_dependencies.dart';
import 'package:project_monitor_server/app_server.dart';
import 'package:project_monitor_server/with_hotreload.dart';

Future<Server> _startServer() async {
  Logger.root.level = Platform.environment['DEBUG_LOG'] == 'true' ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  final dependencies = AppDependencies.shared;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final server = await startAppServer(dependencies, port: port);

  stdout.writeln('Serving at http://localhost:${server.port}');

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
