import 'package:grpc/grpc.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:logging/logging.dart';

final _logger = Logger('HotReload');

void withHotreload(Future<Server> Function() startServer) async {
  Server? runningServer;

  Future<void> obtainNewServer() async {
    if (runningServer != null) {
      _logger.info('Application reloading');
    }

    await runningServer?.shutdown();
    runningServer = await startServer();
  }

  await HotReloader.create(onAfterReload: (ctx) {
    obtainNewServer();
  });

  await obtainNewServer();
}
