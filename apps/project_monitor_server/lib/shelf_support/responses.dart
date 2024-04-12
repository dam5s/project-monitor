import 'dart:convert';

import 'package:shelf/shelf.dart';

abstract class Responses {
  static Response json(dynamic json) =>
      Response.ok(jsonEncode(json), headers: {'content-type': 'application/json'});
}
