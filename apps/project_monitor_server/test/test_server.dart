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

  Uri _url(String path) => Uri.parse('http://localhost:${_server.port}$path');

  Future<Response?> _request(HttpRequest request) async =>
      _clientProvider.withHttpClient((client) async {
        final result = await client.sendRequest(request);
        return result.orNull();
      });

  Future<Response?> get(String path) async => //
      _request(HttpGet(_url(path)));

  Future<Response?> post(String path, {dynamic body}) async => //
      _request(HttpPost(_url(path), body: body));

  Future<void> close() {
    return _server.close();
  }
}
