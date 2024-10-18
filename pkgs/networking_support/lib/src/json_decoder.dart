import 'dart:convert';

typedef JsonObject = Map<String, dynamic>;
typedef JsonArray<T> = List<T>;
typedef JsonObjectArray = JsonArray<JsonObject>;

/// Be careful with this class.
/// It will throw `TypeError` if casting fails.
/// See `http.dart` for safe handling.
final class JsonDecoder {
  final JsonObject _jsonValue;

  JsonDecoder(this._jsonValue);

  /// This throws if the String is not a JSON object
  factory JsonDecoder.fromString(String json) => JsonDecoder(jsonDecode(json) as JsonObject);

  /// This throws if the object is not a JsonObject
  factory JsonDecoder.fromValue(dynamic object) => JsonDecoder(object as JsonObject);

  /// This throws if the value for the field is not of type T or the decode call fails
  T field<T>(String name, {JsonDecode<T>? decode, T Function(dynamic)? map}) {
    final value = _jsonValue[name];

    if (decode != null) {
      return decode(JsonDecoder.fromValue(value));
    }

    if (map != null) {
      return map(_jsonValue[name]);
    }

    return value as T;
  }

  T map<T>(T Function(dynamic) mapping) {
    return mapping(_jsonValue);
  }

  /// This throws if the value for the field is not of type T or the decode call fails
  T? optionalField<T>(String name, {JsonDecode<T?>? decode}) {
    final value = _jsonValue[name];

    if (decode == null) {
      return value as T?;
    }

    return decode(JsonDecoder.fromValue(value));
  }

  /// This throws if the field is not an array of objects that match the decoder
  Iterable<T> objectArray<T>(String name, JsonDecode<T> decode) {
    return (_jsonValue[name] as JsonArray<dynamic>)
        .map((e) => decode(JsonDecoder.fromValue(e)))
        .toList();
  }

  /// This throws if the field is not an array of objects that match the type of T
  Iterable<T> valueArray<T>(String name) {
    return (_jsonValue[name] as JsonArray<dynamic>).map((e) => e as T).toList();
  }
}

typedef JsonDecode<T> = T Function(JsonDecoder json);
