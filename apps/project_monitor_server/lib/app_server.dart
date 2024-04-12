import 'dart:io';

import 'package:shelf/shelf_io.dart';

import 'app_dependencies.dart';
import 'app_handler.dart';

Future<HttpServer> buildAppServer(AppDependencies dependencies, {required int port}) async {
  final server = await serve(await buildAppHandler(dependencies), '0.0.0.0', port);

  server.autoCompress = true;

  return server;
}
