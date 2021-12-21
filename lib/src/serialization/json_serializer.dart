import 'dart:convert';

/// JSON serializer based on Dart's [JsonEncoder].
class JsonSerializer {
  JsonSerializer({String? indent}) : _encoder = JsonEncoder.withIndent(indent);

  final JsonEncoder _encoder;

  /// JSON conversion based on Dart's [JsonEncoder].
  String serialize(Map<String, dynamic> map) => _encoder.convert(map);
}
