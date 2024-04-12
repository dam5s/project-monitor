import 'dart:io';

import 'package:http_support/http_support.dart';
import 'package:test/test.dart';

import '../test_server.dart';

void main() {
  late TestServer server;

  setUp(() async {
    server = await TestServer.start();
  });

  tearDown(() async {
    await server.close();
  });

  test('GET /projects', () async {
    final response = await server.request(HttpMethod.get, '/projects');

    expect(response?.statusCode, equals(HttpStatus.ok));
    expect(response?.body, equals('{"projects":[]}'));
    expect(response?.headers['content-type'], equals('application/json'));
  });
}
