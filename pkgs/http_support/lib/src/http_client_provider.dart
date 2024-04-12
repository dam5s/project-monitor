import 'dart:async';

import 'package:http/http.dart';

abstract class HttpClientProvider {
  Future<T> withHttpClient<T>(FutureOr<T> Function(Client client) block);
}

class ConcreteHttpClientProvider implements HttpClientProvider {
  @override
  Future<T> withHttpClient<T>(FutureOr<T> Function(Client) block) async {
    final client = Client();
    try {
      return await block(client);
    } finally {
      client.close();
    }
  }
}
