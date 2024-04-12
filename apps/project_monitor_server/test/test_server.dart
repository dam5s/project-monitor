import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_support/http_support.dart';
import 'package:prelude/prelude.dart';
import 'package:project_monitor_server/app_dependencies.dart';
import 'package:project_monitor_server/app_server.dart';

class TestServer {
  final AppDependencies dependencies;

  final HttpServer _server;
  final HttpClientProvider _clientProvider = ConcreteHttpClientProvider();

  TestServer._(this._server, this.dependencies);

  static Future<TestServer> start() async {
    final dependencies = AppDependencies.defaults();
    final server = await buildAppServer(dependencies, port: 0);
    return TestServer._(server, dependencies);
  }

  Future<Response?> request(HttpMethod method, String path) async =>
      _clientProvider.withHttpClient((client) async {
        final result = await client.sendRequest(
          HttpMethod.get,
          Uri.parse('http://localhost:${_server.port}$path'),
        );

        return result.orNull();
      });

  Future<void> close() {
    return _server.close();
  }
}
