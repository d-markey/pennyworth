import 'dart:convert';

import 'serialization_exception.dart';

/// JSON serializer based on Dart's [JsonEncoder].
class JsonSerializer {
  factory JsonSerializer({required String indent}) =>
      _cache.putIfAbsent(indent, () => JsonSerializer._(indent));

  static final _cache = <String, JsonSerializer>{};

  JsonSerializer._(String indent) : _encoder = JsonEncoder.withIndent(indent);

  final JsonEncoder _encoder;

  /// JSON conversion based on Dart's [JsonEncoder].
  String serialize(Map<String, dynamic> map) {
    try {
      return _encoder.convert(map);
    } catch (e) {
      throw SerializationException('Error in JsonEncoder.convert()', e);
    }
  }
}
