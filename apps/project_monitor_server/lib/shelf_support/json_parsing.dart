import 'package:http_support/http_support.dart';
import 'package:prelude/prelude.dart';
import 'package:shelf/shelf.dart';

extension RequestJson on Request {
  Future<Result<T, String>> tryParse<T>(JsonDecode<T> decode) async {
    try {
      final body = await readAsString();
      final decoder = JsonDecoder.fromString(body);
      return Ok(decode(decoder));
    } on TypeError catch (e) {
      return Err('Failed to parse json $e');
    }
  }
}
