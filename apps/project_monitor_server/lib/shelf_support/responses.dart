import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

abstract class Responses {
  static Response json(dynamic json, {int? code}) => Response(
        code ?? HttpStatus.ok,
        body: jsonEncode(json),
        headers: {'content-type': 'application/json'},
      );
}
