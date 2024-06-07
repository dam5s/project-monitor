import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:hotreloader/hotreloader.dart';

void withHotreload(Future<Server> Function() startServer) async {
  Server? runningServer;

  Future<void> obtainNewServer() async {
    if (runningServer != null) {
      final time = _formatTime(DateTime.now());
      stdout.writeln('[hotreload] $time - Application reloading.');
    }

    await runningServer?.shutdown();
    runningServer = await startServer();
  }

  await HotReloader.create(onAfterReload: (ctx) {
    obtainNewServer();
  });

  await obtainNewServer();
}

String _formatTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  final second = time.second.toString().padLeft(2, '0');
  return '$hour:$minute:$second';
}
