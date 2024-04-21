import 'dart:convert';

import 'package:shelf/shelf.dart';

abstract class Responses {
  static Response json(dynamic json, {int? code}) => Response(
        code ?? 200,
        body: jsonEncode(json),
        headers: {'content-type': 'application/json'},
      );
}
