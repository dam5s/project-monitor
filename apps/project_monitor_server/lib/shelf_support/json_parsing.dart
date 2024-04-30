import 'dart:io';

import 'package:http_support/http_support.dart';
import 'package:prelude/prelude.dart';
import 'package:shelf/shelf.dart';

import 'responses.dart';

extension RequestJson on Request {
  FutureResult<T, Response> tryParse<T>(JsonDecode<T> decode) async {
    try {
      final body = await readAsString();
      final decoder = JsonDecoder.fromString(body);
      return Ok(decode(decoder));
    } on TypeError catch (e) {
      return Err(
        Responses.json(
          {'error': 'Failed to decode JSON, $e'},
          code: HttpStatus.badRequest,
        ),
      );
    }
  }
}
