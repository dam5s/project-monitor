import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';
import 'package:project_monitor_server/app_dependencies.dart';
import 'package:project_monitor_server/app_server.dart';
import 'package:project_monitor_server/with_hotreload.dart';

final _logger = Logger('server');

Future<Server> _startServer(AppDependencies dependencies) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final server = await startAppServer(dependencies, port: port);

  _logger.info('Serving at http://localhost:${server.port}');

  return server;
}

Future<void> main() async {
  Logger.root.level = Platform.environment['DEBUG_LOG'] == 'true' ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final useHotreload = Platform.environment['USE_HOTRELOAD'] == 'true';

  final dependencies = AppDependencies.defaults();
  final runner = dependencies.runner;
  final loader = dependencies.loader;
  final updater = dependencies.updater;

  await loader.load();

  runner.runPeriodically(
    callback: updater.run,
    every: const Duration(seconds: 120),
  );

  if (useHotreload) {
    withHotreload(() => _startServer(dependencies));
  } else {
    await _startServer(dependencies);
  }
}
