import 'package:async_support/async_support.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:prelude/prelude.dart';

import 'http_error.dart';
import 'json_decoder.dart';

final _logger = Logger('http');

enum HttpMethod {
  get;

  @override
  String toString() => switch (this) {
        get => 'GET',
      };
}

typedef HttpResult<T> = Result<T, HttpError>;
typedef HttpFuture<T> = Future<HttpResult<T>>;

extension SendRequest on Client {
  HttpFuture<Response> sendRequest(HttpMethod method, Uri url) async {
    try {
      final request = Request(method.toString(), url)..followRedirects = false;
      final streamedResponse = await send(request);
      final response = await Response.fromStream(streamedResponse);

      return Ok(response);
    } on Exception catch (e) {
      _logger.warning("Exception during request $method $url", e);
      return Err(HttpConnectionError(e));
    }
  }
}

extension ResponseHandling on HttpResult<Response> {
  HttpResult<Response> expectStatusCode(int expected) => flatMapOk((response) {
        if (response.statusCode == expected) {
          return Ok(response);
        } else {
          _logger.warning(
            "Unexpected status code, expected $expected, got ${response.statusCode}",
          );
          return Err(HttpUnexpectedStatusCodeError(expected, response.statusCode));
        }
      });

  HttpFuture<T> tryParseJson<T>(JsonDecode<T> decode, {required AsyncCompute async}) async {
    return switch (this) {
      Ok(value: final response) => async.compute(
          (response) {
            try {
              final jsonObject = JsonDecoder.fromString(response.body);
              final object = decode(jsonObject);
              return Ok(object);
            } on TypeError catch (e) {
              _logger.severe('Failed to parse json: ${response.body}', e);
              return Err(HttpDeserializationError(e, response.body));
            }
          },
          response,
        ),
      Err(:final error) => Future.value(Err(error)),
    };
  }
}
