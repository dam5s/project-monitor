import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:prelude/prelude.dart';

import 'async_compute.dart';
import 'http_error.dart';
import 'json_decoder.dart';

sealed class HttpRequest {
  abstract final String method;
  abstract final Uri url;
  abstract final dynamic body;
}

final class HttpGet implements HttpRequest {
  @override
  final String method = 'GET';
  @override
  final Uri url;
  @override
  final dynamic body = null;

  HttpGet(this.url);
}

final class HttpPost implements HttpRequest {
  @override
  final String method = 'POST';
  @override
  final Uri url;
  @override
  final dynamic body;

  HttpPost(this.url, {this.body});
}

final class HttpDelete implements HttpRequest {
  @override
  final String method = 'DELETE';
  @override
  final Uri url;
  @override
  final dynamic body = null;

  HttpDelete(this.url);
}

final class HttpPut implements HttpRequest {
  @override
  final String method = 'PUT';
  @override
  final Uri url;
  @override
  final dynamic body;

  HttpPut(this.url, {this.body});
}

typedef HttpResult<T> = Result<T, HttpError>;
typedef HttpFuture<T> = Future<HttpResult<T>>;

extension SendRequest on Client {
  Request _buildRequest(HttpRequest request) {
    final r = Request(request.method, request.url);
    r.followRedirects = false;

    if (request.body != null) {
      r.headers['Content-Type'] = 'application/json';
      r.body = jsonEncode(request.body);
    }

    return r;
  }

  HttpFuture<Response> sendRequest(HttpRequest request) async {
    try {
      final streamedResponse = await send(_buildRequest(request));
      final response = await Response.fromStream(streamedResponse);

      return Ok(response);
    } on Exception catch (e) {
      _logger.w("Exception during request $request.method $request.url", error: e);
      return Err(HttpConnectionError(e));
    }
  }
}

extension ResponseHandling on HttpResult<Response> {
  HttpResult<Response> expectStatusCode(int expected) => flatMapOk((response) {
        if (response.statusCode == expected) {
          return Ok(response);
        } else {
          _logger.w("Unexpected status code, expected $expected, got ${response.statusCode}");
          return Err(HttpUnexpectedStatusCodeError(expected, response.statusCode));
        }
      });

  HttpFuture<T> tryParseJson<T>(JsonDecode<T> decode, {required AsyncCompute async}) async {
    return switch (this) {
      Ok(:final value) => async.compute(
          (response) {
            try {
              final jsonObject = JsonDecoder.fromString(response.body);
              final object = decode(jsonObject);
              return Ok(object);
            } on TypeError catch (e) {
              _logger.e('Failed to parse json: ${response.body}', error: e);
              return Err(HttpDeserializationError(e, response.body));
            }
          },
          value,
        ),
      Err(:final error) => Future.value(Err(error)),
    };
  }
}

final _logger = Logger();
