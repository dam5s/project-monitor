import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:project_monitor_server/app_dependencies.dart';
import 'package:project_monitor_server/app_server.dart';
import 'package:projects_api/projects_api.pbgrpc.dart';

class TestServer {
  final AppDependencies dependencies;
  final Server _server;
  final ClientChannel _clientChannel;

  TestServer._(this._server, this._clientChannel, this.dependencies);

  static Future<TestServer> start() async {
    final dependencies = AppDependencies.defaults();
    final server = await startAppServer(dependencies, port: 0);

    final clientChannel = ClientChannel(
      'localhost',
      port: server.port ?? 0,
      options: ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );

    return TestServer._(server, clientChannel, dependencies);
  }

  ProjectsApiClient projectsApiClient() => ProjectsApiClient(_clientChannel);

  Future<void> close() {
    return _server.shutdown();
  }
}
