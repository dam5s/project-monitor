import 'dart:async';

import 'package:http/http.dart';

abstract class HttpClientProvider {
  FutureOr<T> withHttpClient<T>(FutureOr<T> Function(Client client) block);
}

class ConcreteHttpClientProvider implements HttpClientProvider {
  @override
  Future<T> withHttpClient<T>(FutureOr<T> Function(Client) block) async {
    final client = Client();
    try {
      final result = await block(client);
      return result;
    } finally {
      client.close();
    }
  }
}
